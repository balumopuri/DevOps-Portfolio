#!/bin/bash

USERID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]
        then 
            echo "$2.... Failure"
            exit 1
        else
            echo "$2.....success"
        fi
}
if [ $USERID -ne 0 ]
then 
    echo "Error:: you must have sudo access to execute the script"
    exit 1
fi

    dnf list installed git 
        if [ $? -ne 0 ]
        then 
            dnf install git -y
         VALIDATE $2 "Installing GIT"
    else                 
        echo "Git is already installed"
    fi
