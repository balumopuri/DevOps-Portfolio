#!/bin/bash

echo "All variables passed: $@"
echo "Number of vaiables: $#"
echo "Script name: $0"
echo "Present working directory: $PWD"
echo "Home dir of current user: $HOME"
echo "which user is running the script: $USER"
echo "process id of the script: $$"
sleep 5 &
echo "process id of last command in background:$!"