#!/bin/bash

source /workspaces/DevOps-Portfolio/color.sh


dnf install ansible -y

ansible-pull \
  -i localhost, \
  -U https://github.com/balumopuri/expense-ansible-roles.git \
  -C main \
  -e COMPONENT=backend \
  -e ENVIRONMENT=$1 \
  backend.yaml     