#!/bin/bash

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

# ---------------------------------------
# kubectl installation
# ---------------------------------------
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/1.32.0/2024-12-20/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv kubectl /usr/local/bin/kubectl
kubectl version --client

# ---------------------------------------
# eksctl installation
# ---------------------------------------
ARCH=amd64
PLATFORM=linux_$ARCH     # was "windows_$ARCH" — fixed for a Linux server

dnf install -y unzip      # unzip not present by default on RHEL/Amazon Linux

curl -sLO "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_$PLATFORM.zip"

# (Optional) Verify checksum
# curl -sL "https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_checksums.txt" | grep $PLATFORM | sha256sum --check

mkdir -p /tmp/eksctl-install
unzip eksctl_$PLATFORM.zip -d /tmp/eksctl-install
rm eksctl_$PLATFORM.zip

chmod +x /tmp/eksctl-install/eksctl
mv /tmp/eksctl-install/eksctl /usr/local/bin/eksctl
eksctl version