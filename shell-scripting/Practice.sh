#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


# TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

# log "Today Date is: $TIMESTAMP"

# log "$(pwd)"

# # log "$( ls -a )"

# log "$( who )"

# log "$( uptime )"

# log "$( df -h / )"

# log "$( ls -1 | wc -l )"
# log "$( head -n 4 16.Loops-install.sh )"

# log "$( grep | colors.sh )"

# log "$( ps -ef )"

# read  num
# if [ $(( num % 2 )) -eq 0 ]; then
#     log "Number is Even"
# else
#     log "Number is Odd"
# fi


# read -p "Enter a number: " num
#     while [ $num -gt 0 ]; 
# do
#     num=$(( num - 1 ))
#     log $num
# done
# log "Lift off!"

BACKUP_FOLDER=~/backups
FILENAME=$(basename "$1")
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_NAME="${FILENAME%.*}_${TIMESTAMP}.${FILENAME##*.}"

if [ -f "$1" ]; then
    mkdir -p "$BACKUP_FOLDER"
    cp "$1" "$BACKUP_FOLDER/$BACKUP_NAME"
    log "Backed up $FILENAME to $BACKUP_FOLDER/$BACKUP_NAME"
else
    log "Error: '$1' does not exist"
    exit 1
fi


