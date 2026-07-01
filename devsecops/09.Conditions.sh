#!/bin/bash

Number=$1

if [ $Number -gt 100 ]
then
    echo "given number is greater than 100"
else
    echo "given number is less than or equal to 100"
fi        
