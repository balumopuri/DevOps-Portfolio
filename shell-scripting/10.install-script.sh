#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then 
    echo "Error:: you must have sudo access to execute the script"
    exit 1
fi


dnf install -y https://repo.mysql.com/mysql80-community-release-el9-1.noarch.rpm \
|| dnf install -y https://repo.mysql.com/mysql80-community-release-el8-1.noarch.rpm

# Install MySQL Server
    dnf install -y mysql-community-server

        if [ $? -ne 0 ]
        then 
            echo "Installing MySQL.... Failure"
            exit 1
        else
            echo "Installing MySQL.....success"
        fi   
    else                 
    echo "MYSQL is already installed"
fi

    dnf list installed git 
        if [ $? -ne 0 ]
        then 
            dnf install git -y
            if [ $? -ne 0 ]
        then
            echo "Installing Git.... Failure"
            exit 1
        else
            echo "Installing Git.....success"
        fi   
    else                 
        echo "Git is already installed"
    fi
















