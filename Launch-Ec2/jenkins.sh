#!/bin/bash


sudo dnf update -y
sudo reboot
sudo dnf install wget -y
Install the wget utility to download files:

sudo dnf install wget -y

# Add the Jenkins repository by running:

sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import the GPG key for Jenkins packages:

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Java 17, a prerequisite for Jenkins:

sudo dnf install -y fontconfig java-17-openjdk

# Verify the Java installation:

java --version

# Install Jenkins using the following command:

sudo dnf install jenkins -y

# Reload the system daemon to recognize Jenkins:

sudo systemctl daemon-reload

# Start and enable the Jenkins service:

sudo systemctl start jenkins
sudo systemctl enable jenkins

# Verify that Jenkins is running:

sudo systemctl status jenkins

# Configure the firewall to allow traffic on port 8080:

sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload

# Access Jenkins via a web browser by navigating to:
















# set -e

# echo "Updating system packages..."
# sudo dnf update -y

# echo "Installing Java 17..."
# sudo dnf install -y java-17-openjdk java-17-openjdk-devel

# echo "Adding Jenkins repository..."
# sudo curl -o /etc/yum.repos.d/jenkins.repo \
# https://pkg.jenkins.io/redhat-stable/jenkins.repo

# echo "Importing Jenkins GPG key..."
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# echo "Installing Jenkins..."
# sudo dnf install -y jenkins

# echo "Enabling and starting Jenkins service..."
# sudo systemctl enable jenkins
# sudo systemctl start jenkins

# echo "Checking Jenkins status..."
# sudo systemctl status jenkins --no-pager

# echo "Configuring firewall for Jenkins (port 8080)..."
# sudo firewall-cmd --permanent --add-port=8080/tcp
# sudo firewall-cmd --reload

# echo ""
# echo "Jenkins installation completed."
# echo "Access Jenkins at:"
# echo "http://$(hostname -I | awk '{print $1}'):8080"
# echo ""
# echo "Initial Admin Password:"
# sudo cat /var/lib/jenkins/secrets/initialAdminPassword