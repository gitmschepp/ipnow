#!/bin/bash

INTERFACE="$1"
FIELD="$2"

if [ $FIELD == "subnet" ]
then  ifconfig $INTERFACE | grep "inet addr" | awk '{print $4}' | awk 'BEGIN {FS=":"} {print $2}' | tr '\n' ' '
else
      ifconfig $INTERFACE | grep "inet addr" | awk '{print $2}' | awk 'BEGIN {FS=":"} {print $2}' | tr '\n' ' '
fi


