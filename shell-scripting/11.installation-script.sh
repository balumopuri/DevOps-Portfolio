#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


USERID=$(id -u)

if [ "$USERID" -ne 0 ]; then
    log "Error:: You must have sudo (root) access to execute the script"
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
        log "Unsupported OS version"
        exit 1
    fi
fi

# Install MySQL
dnf list installed mysql-community-server &>/dev/null
if [ $? -ne 0 ]; then
    dnf install -y mysql-community-server
    if [ $? -ne 0 ]; then
        log "Installing MySQL.... FAILURE"
        exit 1
    else
        log "Installing MySQL.... SUCCESS"
    fi
else
    log "MySQL is already installed"
fi

# Install Git
dnf list installed git &>/dev/null
if [ $? -ne 0 ]; then
    dnf install -y git
    if [ $? -ne 0 ]; then
        log "Installing Git.... FAILURE"
        exit 1
    else
        log "Installing Git.... SUCCESS"
    fi
else
    log "Git is already installed"
fi