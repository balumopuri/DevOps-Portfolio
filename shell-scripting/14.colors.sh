#!/bin/bash

R="/e[31m"
G="/e[32m"
Y="/e[33m"

USERID=$(id -u)

VALIDATE(){
    if [ $1 -ne 0 ]
        then 
            echo -e "$2.... $R Failure"
            exit 1
        else
            echo -e "$2.....$G success"
        fi
}
if [ $USERID -ne 0 ]
then 
    echo -e $R "Error:: you must have sudo access to execute the script"
    exit 1
fi

    dnf list installed git 
        if [ $? -ne 0 ]
        then 
            dnf install git -y
         VALIDATE $2 "Installing GIT"
    else                 
        echo -e $G "Git is already installed"
    fi