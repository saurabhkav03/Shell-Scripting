#!/bin/bash

#####################################
# Author: Saurabh
# Date: 10/03/2024
#
# This script outputs the node health
#
# Version: v1
######################################

set -x # debug mode: will list the command run in output
set -e # exit script when there is an error
set -o pipefail

#set -exo # can use all 3 parameters but not recommended

df -h

free -g

nproc

ps -ef | grep python | awk -F" " '{print$2}'  # will print process id