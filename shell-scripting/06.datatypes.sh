#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


NUMBER1=$1
NUMBER2=$2

TIMESTAMP=$(date)
log "Script executed at : $TIMESTAMP"

SUM=$(($NUMBER1 + $NUMBER2))
log "SUM of $NUMBER1 and $NUMBER2 is: $SUM"