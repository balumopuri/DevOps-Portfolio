#!/bin/bash
set -uo pipefail

ARCH=amd64
PLATFORM=linux_$ARCH

# ---------------------------------------
# Disk / LVM expansion
# ---------------------------------------
growpart /dev/nvme0n1 4
lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol
xfs_growfs /
xfs_growfs /var

# ---------------------------------------
# Docker installation
# ---------------------------------------
dnf -y install dnf-plugins-core
dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user

echo "=== Docker version ==="
docker --version || echo "WARNING: docker command not found after install"

# ---------------------------------------
# kubectl installation
# ---------------------------------------
cd ~ || exit 1
echo "=== Downloading kubectl ==="
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl

if [ ! -f ./kubectl ]; then
    echo "ERROR: kubectl download failed - file not found after curl"
else
    chmod +x ./kubectl
    mv ./kubectl /usr/local/bin/kubectl
    if [ -f /usr/local/bin/kubectl ]; then
        echo "kubectl moved to /usr/local/bin successfully"
        /usr/local/bin/kubectl version --client
    else
        echo "ERROR: kubectl mv failed - check permissions on /usr/local/bin"
    fi
fi

# ---------------------------------------
# eksctl installation
# ---------------------------------------
dnf install -y unzip

echo "=== Downloading eksctl ==="
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.zip"

# Verify the downloaded file is actually a zip before attempting to unzip it
FILETYPE=$(file --brief eksctl_$PLATFORM.zip 2>/dev/null || echo "unknown")
echo "Downloaded file type: $FILETYPE"

if [[ "$FILETYPE" != Zip* ]]; then
    echo "ERROR: eksctl download did not return a valid zip file."
    echo "First 300 bytes of the downloaded file for diagnosis:"
    head -c 300 eksctl_$PLATFORM.zip
    echo ""
    echo "This usually means GitHub returned an error page instead of the binary"
    echo "(possible outbound network/firewall/security-group restriction to github.com"
    echo "or githubusercontent.com release asset CDN). Retrying once..."

    rm -f eksctl_$PLATFORM.zip
    curl -sL -o eksctl_$PLATFORM.zip "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.zip"
    FILETYPE=$(file --brief eksctl_$PLATFORM.zip 2>/dev/null || echo "unknown")
    echo "Retry downloaded file type: $FILETYPE"
fi

if [[ "$FILETYPE" == Zip* ]]; then
    mkdir -p /tmp/eksctl-install
    unzip -o eksctl_$PLATFORM.zip -d /tmp/eksctl-install
    rm -f eksctl_$PLATFORM.zip

    if [ -f /tmp/eksctl-install/eksctl ]; then
        chmod +x /tmp/eksctl-install/eksctl
        mv /tmp/eksctl-install/eksctl /usr/local/bin/eksctl
        echo "eksctl moved to /usr/local/bin successfully"
        /usr/local/bin/eksctl version
    else
        echo "ERROR: eksctl binary not found inside extracted zip"
        ls -la /tmp/eksctl-install
    fi
else
    echo "ERROR: eksctl download still invalid after retry. Skipping install."
    echo "Check outbound network access from this instance to github.com and"
    echo "release-assets.githubusercontent.com (security groups / NACLs / proxy)."
fi

# ---------------------------------------
# Final summary
# ---------------------------------------
echo ""
echo "======================================"
echo "           INSTALL SUMMARY"
echo "======================================"
echo -n "Docker : "; docker --version 2>/dev/null || echo "NOT INSTALLED"
echo -n "kubectl: "; kubectl version --client 2>/dev/null || echo "NOT INSTALLED"
echo -n "eksctl : "; eksctl version 2>/dev/null || echo "NOT INSTALLED"