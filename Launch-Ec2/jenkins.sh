#!/bin/bash

# Add the Jenkins repository
sudo wget -O /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/rpm-stable/jenkins.repo

# Import the Jenkins GPG key
sudo rpm --import https://pkg.jenkins.io/rpm-stable/jenkins.io-2023.key

# Update package metadata
sudo yum makecache

# Upgrade installed packages (optional)
sudo yum -y upgrade

# Install Java 21 and fontconfig
sudo yum install -y fontconfig java-21-openjdk

# Install Jenkins
sudo yum install -y jenkins

# Reload systemd
sudo systemctl daemon-reload

# Enable Jenkins to start on boot
sudo systemctl enable jenkins

# Start Jenkins
sudo systemctl start jenkins

# Verify service status
sudo systemctl status jenkins --no-pager

# Display the initial admin password
echo ""
echo "Initial Jenkins Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword