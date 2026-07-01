#!/bin/bash

USERID=$(id -u)

if [ "$USERID" -ne 0 ]; then
    echo "Error:: You must have sudo (root) access to execute the script"
    exit 1
fi

# Detect OS major version
OS_VERSION=$(rpm -E %{rhel})

# Add MySQL repo if not already added
if ! dnf repolist | grep -q mysql; then
    if [ "$OS_VERSION" -eq 9 ]; then
        dnf install -y https://repo.mysql.com/mysql80-community-release-el9-1.noarch.rpm
    elif [ "$OS_VERSION" -eq 8 ]; then
        dnf install -y https://repo.mysql.com/mysql80-community-release-el8-1.noarch.rpm
    else
        echo "Unsupported OS version"
        exit 1
    fi
fi

# Install MySQL
dnf list installed mysql-community-server &>/dev/null
if [ $? -ne 0 ]; then
    dnf install -y mysql-community-server
    if [ $? -ne 0 ]; then
        echo "Installing MySQL.... FAILURE"
        exit 1
    else
        echo "Installing MySQL.... SUCCESS"
    fi
else
    echo "MySQL is already installed"
fi

# Install Git
dnf list installed git &>/dev/null
if [ $? -ne 0 ]; then
    dnf install -y git
    if [ $? -ne 0 ]; then
        echo "Installing Git.... FAILURE"
        exit 1
    else
        echo "Installing Git.... SUCCESS"
    fi
else
    echo "Git is already installed"
fi