#!/bin/bash

set -e

echo "Updating system packages..."
sudo dnf update -y

echo "Installing Java 17..."
sudo dnf install -y java-17-openjdk java-17-openjdk-devel

echo "Adding Jenkins repository..."
sudo curl -o /etc/yum.repos.d/jenkins.repo \
https://pkg.jenkins.io/redhat-stable/jenkins.repo

echo "Importing Jenkins GPG key..."
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "Installing Jenkins..."
sudo dnf install -y jenkins

echo "Enabling and starting Jenkins service..."
sudo systemctl enable jenkins
sudo systemctl start jenkins

echo "Checking Jenkins status..."
sudo systemctl status jenkins --no-pager

echo "Configuring firewall for Jenkins (port 8080)..."
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

echo ""
echo "Jenkins installation completed."
echo "Access Jenkins at:"
echo "http://$(hostname -I | awk '{print $1}'):8080"
echo ""
echo "Initial Admin Password:"
sudo cat /var/lib/jenkins/secrets/initialAdminPassword