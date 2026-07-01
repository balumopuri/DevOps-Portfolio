#!/bin/bash

# TIMESTAMP=$(date +"%Y-%m-%d-%H-%M-%S")

# echo "Today Date is: $TIMESTAMP"

# echo "$(pwd)"

# # echo "$( ls -a )"

# echo "$( who )"

# echo "$( uptime )"

# echo "$( df -h / )"

# echo "$( ls -1 | wc -l )"
# echo "$( head -n 4 16.Loops-install.sh )"

# echo "$( grep | colors.sh )"

# echo "$( ps -ef )"

# read  num
# if [ $(( num % 2 )) -eq 0 ]; then
#     echo "Number is Even"
# else
#     echo "Number is Odd"
# fi


# read -p "Enter a number: " num
#     while [ $num -gt 0 ]; 
# do
#     num=$(( num - 1 ))
#     echo $num
# done
# echo "Lift off!"

BACKUP_FOLDER=~/backups
FILENAME=$(basename "$1")
TIMESTAMP=$(date +"%Y-%m-%d")
BACKUP_NAME="${FILENAME%.*}_${TIMESTAMP}.${FILENAME##*.}"

if [ -f "$1" ]; then
    mkdir -p "$BACKUP_FOLDER"
    cp "$1" "$BACKUP_FOLDER/$BACKUP_NAME"
    echo "Backed up $FILENAME to $BACKUP_FOLDER/$BACKUP_NAME"
else
    echo "Error: '$1' does not exist"
    exit 1
fi


