#!/bin/bash

#####################################
# Author: Saurabh
# Date: 11/03/2024
# 
# List people who has access to the repository
#
# Version: v1
#####################################


# GitHub API URL
API_URL="https://api.github.com" #The varaible holds the base URL of github api

# Github username and access token
USERNAME=$username
TOKEN=$token

# Pass user/organization and repo name while exececuting the script
REPO_OWNER=$1
REPO_NAME=$2

# Function to list users with read access
function list_users_with_read_access {

    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"
    
    local url="${API_URL}/${endpoint}"

# Send a GET request to the GitHub API with authentication

# The -s flag makes curl operate silently, and the -u flag provides authentication with the username and token.
#    local collaborators=$( curl -s -u "${USERNAME}:${TOKEN}" "$url" )
    local collaborators=$(curl -s -u "${USERNAME}:${TOKEN}" "$url" | jq -r '.[] | select(.permissions.admin == true) | .login') # extracts only the usernames


# Display the list of collaborators with read access

    if [[ -z $collaborators ]];
    then
        echo "There are no users with read access in ${REPO_OWNER}/${REPO_NAME}"
    else
        echo "The number users with read access in ${REPO_OWNER}/${REPO_NAME} are:"
        echo "$collaborators"
    fi 
}

# Main script

echo "Listing user with read access in ${REPO_OWNER}/${REPO_NAME} are ....."
echo ""
list_users_with_read_access
