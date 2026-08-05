#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh

set -Eeuo pipefail

ARCH=amd64
K8S_VERSION="1.32.0"
K8S_RELEASE_DATE="2024-12-20"

#---------------------------------------
# Root check
#---------------------------------------
if [[ $EUID -ne 0 ]]; then
    log "ERROR: This script must be run as root."
    exit 1
fi

#---------------------------------------
# Install prerequisites
#---------------------------------------
log "=== Installing prerequisites ==="
dnf -y install \
    curl \
    tar \
    file \
    cloud-utils-growpart \
    dnf-plugins-core

#---------------------------------------
# Disk / LVM expansion
#---------------------------------------
log "=== Expanding disk ==="

growpart /dev/nvme0n1 4 || true

lvextend -l +50%FREE /dev/RootVG/rootVol
lvextend -l +50%FREE /dev/RootVG/varVol

xfs_growfs /
xfs_growfs /var

#---------------------------------------
# Docker installation
#---------------------------------------
log "=== Installing Docker ==="

dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/rhel/docker-ce.repo

dnf install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin

systemctl enable --now docker

if ! systemctl is-active --quiet docker; then
    log "ERROR: Docker service failed to start."
    exit 1
fi

if id ec2-user &>/dev/null; then
    usermod -aG docker ec2-user
fi

log "Docker installed:"
docker --version

#---------------------------------------
# kubectl installation
#---------------------------------------
log "=== Installing kubectl ==="

cd /tmp

curl -fLo kubectl \
"https://s3.us-west-2.amazonaws.com/amazon-eks/${K8S_VERSION}/${K8S_RELEASE_DATE}/bin/linux/${ARCH}/kubectl"

FILETYPE=$(file --brief kubectl)

if [[ "$FILETYPE" != *ELF* ]]; then
    log "ERROR: kubectl download is invalid."
    exit 1
fi

chmod +x kubectl
mv kubectl /usr/local/bin/

log "kubectl installed:"
kubectl version --client

#---------------------------------------
# eksctl installation
#---------------------------------------
log "=== Installing eksctl ==="

EKSCTL_PLATFORM="Linux_${ARCH}"

curl -fsSLo eksctl.tar.gz \
"https://github.com/eksctl-io/eksctl/releases/latest/download/eksctl_${EKSCTL_PLATFORM}.tar.gz"

FILETYPE=$(file --brief eksctl.tar.gz)

if [[ "$FILETYPE" != gzip* ]]; then
    log "ERROR: Invalid eksctl archive downloaded."
    exit 1
fi

mkdir -p /tmp/eksctl-install

tar -xzf eksctl.tar.gz -C /tmp/eksctl-install

install -m 0755 \
/tmp/eksctl-install/eksctl \
/usr/local/bin/eksctl

rm -rf \
/tmp/eksctl-install \
eksctl.tar.gz

log "eksctl installed:"
eksctl version

#---------------------------------------
# Helm installation
#---------------------------------------
log "=== Installing Helm ==="



curl -fsSL -o get_helm.sh \
https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh

rm -f get_helm.sh

log "Helm installed:"
helm version --short

#---------------------------------------
# Final summary
#---------------------------------------
log
log "========================================="
log "          INSTALLATION SUMMARY"
log "========================================="

log -n "Docker  : "
docker --version

log -n "kubectl : "
kubectl version --client

log -n "eksctl  : "
eksctl version

log -n "Helm    : "
helm version --short

log
log "Provisioning completed successfully."