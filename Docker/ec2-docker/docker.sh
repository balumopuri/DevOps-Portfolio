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
# NOTE: The Linux release asset from eksctl-io is a .tar.gz (NOT .zip),
# and the OS portion of the filename is capitalized: "Linux", not "linux".
# .zip is only used for the Windows asset. Using the wrong name/extension
# returns a GitHub 404 ("Not Found") rather than a real binary.
EKSCTL_OS=Linux
EKSCTL_PLATFORM=${EKSCTL_OS}_${ARCH}

echo "=== Downloading eksctl ==="
curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${EKSCTL_PLATFORM}.tar.gz"

# Verify the downloaded file is actually a gzip archive before attempting to extract it
FILETYPE=$(file --brief eksctl_${EKSCTL_PLATFORM}.tar.gz 2>/dev/null || echo "unknown")
echo "Downloaded file type: $FILETYPE"

if [[ "$FILETYPE" != gzip* ]]; then
    echo "ERROR: eksctl download did not return a valid gzip archive."
    echo "First 300 bytes of the downloaded file for diagnosis:"
    head -c 300 eksctl_${EKSCTL_PLATFORM}.tar.gz
    echo ""
    echo "This usually means GitHub returned an error page instead of the binary"
    echo "(possible outbound network/firewall/security-group restriction to github.com"
    echo "or release-assets.githubusercontent.com CDN). Retrying once..."

    rm -f eksctl_${EKSCTL_PLATFORM}.tar.gz
    curl -sL -o eksctl_${EKSCTL_PLATFORM}.tar.gz "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${EKSCTL_PLATFORM}.tar.gz"
    FILETYPE=$(file --brief eksctl_${EKSCTL_PLATFORM}.tar.gz 2>/dev/null || echo "unknown")
    echo "Retry downloaded file type: $FILETYPE"
fi

if [[ "$FILETYPE" == gzip* ]]; then
    mkdir -p /tmp/eksctl-install
    tar -xzf eksctl_${EKSCTL_PLATFORM}.tar.gz -C /tmp/eksctl-install
    rm -f eksctl_${EKSCTL_PLATFORM}.tar.gz

    if [ -f /tmp/eksctl-install/eksctl ]; then
        chmod +x /tmp/eksctl-install/eksctl
        mv /tmp/eksctl-install/eksctl /usr/local/bin/eksctl
        echo "eksctl moved to /usr/local/bin successfully"
        /usr/local/bin/eksctl version
    else
        echo "ERROR: eksctl binary not found inside extracted archive"
        ls -la /tmp/eksctl-install
    fi
else
    echo "ERROR: eksctl download still invalid after retry. Skipping install."
    echo "Check outbound network access from this instance to github.com and"
    echo "release-assets.githubusercontent.com (security groups / NACLs / proxy)."
fi

#--------------------------------

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
/get_helm.sh

# ---------------------------------------
# Final summary
# ---------------------------------------
echo ""
echo "======================================"
echo "           INSTALL SUMMARY"
echo "======================================"
echo -n "Docker : "; docker --version 2>/dev/null || echo "NOT INSTALLED"
echo -n "kubectl: "; /usr/local/bin/kubectl version --client 2>/dev/null || echo "NOT INSTALLED"
echo -n "eksctl : "; /usr/local/bin/eksctl version 2>/dev/null || echo "NOT INSTALLED"