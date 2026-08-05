#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


log "All variables passed: $@"
log "Number of vaiables: $#"
log "Script name: $0"
log "Present working directory: $PWD"
log "Home dir of current user: $HOME"
log "which user is running the script: $USER"
log "process id of the script: $$"
sleep 5 &
log "process id of last command in background:$!"