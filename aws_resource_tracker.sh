#!/bin/bash

#########################
# Author: Saurabh
# Date: 10/03/2024
# 
# Version: v1
#
# This script will report the AWS resource usage
##########################

set -x # debug mode: will list the command run in output
set -e # exit script when there is an error
set -o pipefail 

# AWS S3
# AWS EC2
# AWS Lambda
# AWS IAM Users

# Output section headers
echo "AWS Resource Usage Report"
echo "-------------------------"

# List AWS S3 Buckets
echo "List of S3 buckets:"
aws s3 ls

# List AWS EC2 Instances
echo "List of EC2 instances:"
#aws ec2 describe-instances 
aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' # will list just instance id using json parser
#aws ec2 describe-instances | jq -r '.Reservations[].Instances[] | "\(.InstanceId) - \(.InstanceType) - \(.State.Name)"'

# List Lamda Functions
echo "List of Lambda functions:"
aws lambda list-functions
#aws lambda list-functions | jq -r '.Functions[] | "\(.FunctionName) - \(.Runtime)"'

# List IAM Users
echo "List of IAM users:"
aws iam list-users
#aws iam list-users | jq -r '.Users[] | "\(.UserName) - \(.CreateDate)"'

