#!/bin/bash

# Add the Jenkins repository
sudo curl -fsSL -o /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/rpm-stable/jenkins.repo

# Import the Jenkins GPG key
sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

# Update package metadata
sudo dnf makecache

# Upgrade installed packages (optional)
# sudo dnf -y upgrade

# Install Java 21 and fontconfig
sudo dnf install -y fontconfig java-21-openjdk

# Install Jenkins
sudo dnf install -y jenkins

# Reload systemd and enable/start Jenkins
sudo systemctl daemon-reload
sudo systemctl enable --now jenkins

# Verify service status
sudo systemctl status jenkins --no-pager

# Display the initial admin password
echo ""
echo "Initial Jenkins Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword