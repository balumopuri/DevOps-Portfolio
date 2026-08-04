#!/usr/bin/env bash

source /workspaces/DevOps-Portfolio/color.sh

set -euo pipefail

if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  BLUE='\033[0;34m'
  NC='\033[0m'
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

log() {
  printf '%b%s%b\n' "$BLUE" "$1" "$NC"
}

warn() {
  printf '%b%s%b\n' "$YELLOW" "$1" "$NC"
}

success() {
  printf '%b%s%b\n' "$GREEN" "$1" "$NC"
}

error() {
  printf '%b%s%b\n' "$RED" "$1" "$NC"
}

# Re-run with sudo if not root
if [ "$(id -u)" -ne 0 ]; then
  warn "Re-running with sudo..."
  exec sudo bash "$0" "$@"
fi

log "Installing Jenkins on RHEL9..."

# Ensure basic tools are available
dnf install -y curl wget gnupg2

# Install Java (OpenJDK 11). Change to java-17-openjdk if you prefer Java 17.
dnf install -y java-11-openjdk

# Add Jenkins repo and import GPG key
log "Adding Jenkins repository..."
curl -fsSL -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key

# Refresh metadata and install Jenkins
dnf clean all
dnf makecache --refresh
dnf install -y jenkins

# Enable and start Jenkins
systemctl daemon-reload
systemctl enable --now jenkins

# If firewalld is present, open port 8080
if systemctl is-active --quiet firewalld; then
  log "Opening port 8080 in firewalld..."
  firewall-cmd --permanent --add-port=8080/tcp
  firewall-cmd --reload
else
  warn "firewalld not active. Ensure AWS Security Group allows inbound TCP/8080."
fi

# Wait a few seconds for Jenkins to create files, then show status and initial admin password
sleep 3
systemctl status jenkins --no-pager || true
printf '\n'
success "=== Initial Jenkins admin password ==="
if [ -f /var/lib/jenkins/secrets/initialAdminPassword ]; then
  cat /var/lib/jenkins/secrets/initialAdminPassword
else
  error "/var/lib/jenkins/secrets/initialAdminPassword not found yet — wait a moment and retry."
fi
printf '\n'
success "Jenkins is installed and running on port 8080. Visit: http://<EC2_PUBLIC_IP>:8080"

