#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR="/home/ec2-user/app-logs"
LOGS_FOLDER="/home/ec2-user/app-logs"
LOG_FILE=$(log $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        log -e "$2 ... $R FAILURE $N"
        exit 1
    else
        log -e "$2 ... $G SUCCESS $N"
    fi
}

FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -mtime +15)
log "Files to be deleted: $FILES_TO_DELETE"

while read -r file
do
    log "Deleting file: $file"
    rm -rf $file
done <<< "$FILES_TO_DELETE"
VALIDATE $? "Deleting old log files"

