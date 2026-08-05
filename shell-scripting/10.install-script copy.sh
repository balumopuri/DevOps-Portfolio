#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


USERID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]
        then 
            log "$2.... Failure"
            exit 1
        else
            log "$2.....success"
        fi
}
if [ $USERID -ne 0 ]
then 
    log "Error:: you must have sudo access to execute the script"
    exit 1
fi


dnf install -y https://repo.mysql.com/mysql80-community-release-el9-1.noarch.rpm \
|| dnf install -y https://repo.mysql.com/mysql80-community-release-el8-1.noarch.rpm

# Install MySQL Server
    dnf install -y mysql-community-server
        VALIDATE $? "Installing MYSQL"
    else                 
    log "MYSQL is already installed"
fi

    dnf list installed git 
        if [ $? -ne 0 ]
        then 
            dnf install git -y
         VALIDATE $2 "Installing GIT"
    else                 
        log "Git is already installed"
    fi
















