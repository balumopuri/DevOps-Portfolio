# #!/bin/bash

# USERID=$(id -u)

# R="/e[31m"
# G="/e[32m"
# Y="/e[33m"
# N="/e[0m"

# LOG_FOLDER="/var/shellscript-logs"
# SCRIPT_NAME=$(basename "$0" .sh)
# TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
# LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

# VALIDATE(){
#     if [ $1 -ne 0 ]
#     then 
#         echo -e "$2......{R} FAILED...${N}" >>"$LOG_FILE_NAME"
#         exit 1
#     else   
#         echo -e "$2 .... ${G}SUCCESS${N}" >> "$LOG_FILE_NAME"
#     fi
# }

# if [ $USERID -ne 0 ]
# then
#     echo -e "${R}Error:: You must have sudo/root access to execute this script${N}"
#     exit 1
# fi

# for package in "$@"
# do
#     dnf list installed $package &>>"$LOG_FILE_NAME"
#     if [ $? -ne 0 ]
#     then   
#         dnf install $package -y &>>"$LOG_FILE_NAME"
#         VALIDATE $? "iNSTALLING $package"
#     else 
#         echo -e "$package is already $(Y).....Installed $N"
#     fi
# done



#!/bin/bash
# Get current user ID

USERID=$(id -u)

# Color codes
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

# Log configuration
LOG_FOLDER="/var/shellscript-logs"
SCRIPT_NAME=$(basename "$0" .sh)
TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")
LOG_FILE_NAME="$LOG_FOLDER/$SCRIPT_NAME-$TIMESTAMP.log"

# Create log directory if it does not exist
mkdir -p "$LOG_FOLDER"

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

# Script start
echo "Script execution started at: $TIMESTAMP" >> "$LOG_FILE_NAME"

# Check for root user
if [ $USERID -ne 0 ]
then
    echo -e "${R}Error:: You must have sudo/root access to execute this script${N}"
    exit 1
fi

# Check if arguments are passed
if [ $# -eq 0 ]
then
    echo -e "${Y}Usage:${N} $0 package1 package2 ..."
    exit 1
fi

# Install packages
for package in "$@"
do
    dnf list installed "$package" &>> "$LOG_FILE_NAME"
    if [ $? -ne 0 ]
    then
        dnf install "$package" -y &>> "$LOG_FILE_NAME"
        VALIDATE $? "Installing $package"
    else
        echo -e "$package is already ${Y}Installed${N}"
    fi
done