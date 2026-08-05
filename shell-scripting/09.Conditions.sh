#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


Number=$1

if [ $Number -gt 100 ]
then
    log "given number is greater than 100"
else
    log "given number is less than or equal to 100"
fi        
