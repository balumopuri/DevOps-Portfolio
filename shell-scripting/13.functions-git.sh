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

    dnf list installed git 
        if [ $? -ne 0 ]
        then 
            dnf install git -y
         VALIDATE $2 "Installing GIT"
    else                 
        log "Git is already installed"
    fi
