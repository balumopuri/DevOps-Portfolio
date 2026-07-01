#!/bin/bash

# Get User ID
USERID=$(id -u)

# Colors (correct escape sequences)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Log configuration
LOG_FOLDER="/var/shellscript-logs"
SCRIPT_NAME=$(basename "$0" .sh)
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

# Create log folder if not exists
mkdir -p $LOG_FOLDER

# Validate function
VALIDATE() {
    if [ $1 -ne 0 ]
    then
        echo -e "$2 .... ${R}FAILED${N}" >> "$LOG_FILE_NAME"
        exit 1
    else
        echo -e "$2 .... ${G}SUCCESS${N}" >> "$LOG_FILE_NAME"
    fi
}

# Script start log
echo "Script execution started at: $TIMESTAMP" >> "$LOG_FILE_NAME"

# Root user validation
if [ $USERID -ne 0 ]
then
    echo -e "${R}Error:: You must have sudo/root access to execute this script${N}"
    exit 1
fi

# Check Git installation
dnf list installed git &>> "$LOG_FILE_NAME"
if [ $? -ne 0 ]
then
    dnf install git -y &>> "$LOG_FILE_NAME"
    VALIDATE $? "Installing Git"
else
    echo -e "${G}Git is already installed${N}"
fi