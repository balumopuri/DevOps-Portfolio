source /workspaces/DevOps-Portfolio/color.sh

# Color codes
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}  # Default to 14 days if not provided


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

USAGE(){
    log -e "$R USAGE:: $N sh.backup.sh <SOURCE_DIR> <DEST_DIR> [DAYS]"
    exit 1
}

if [ $# -lt 2 ]
then
    USAGE
    exit 1
fi

if [ ! -d $SOURCE_DIR ]
then
    log -e "$R ERROR:: Source directory does not exist $N"
    USAGE
    exit 1
fi

if [ ! -d $DEST_DIR ]
then
    log -e "$R ERROR:: Destination directory does not exist $N"
    USAGE
    exit 1
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)
log "Files to be backed up: $FILES"

if [ -n "$FILES" ]
then
   log "FILES are: $FILES"
   ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip"
   find $SOURCE_DIR -name "*.log" -mtime +$DAYS -exec zip "$ZIP_FILE" {} +
else
   log "No files to backup"
   exit 0
fi 