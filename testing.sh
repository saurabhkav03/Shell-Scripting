#!/bin/bash

# Function to print section headers
print_header() {
    echo " "
    echo "############### $1 ###############"
    echo " "
}

# Ping Test
print_header "Ping Test"
ping 8.8.8.8 -c 3

# VPS Network
print_header "IP Address"
ifconfig eth0 | grep inet | head -n 1
echo " "
echo "Gateway:"
ip r | head -n 1
echo " "
echo "VPS network config file:"
cat /etc/sysconfig/network-scripts/ifcfg-eth0

# Disk Size
print_header "Disk Size"
df -Th | grep /dev/vda
echo " "
lsblk 
echo " "
echo "/etc/fstab file entries:"
cat /etc/fstab | tail -n 4

# RAM
print_header "RAM"
free -h

# Hostname
print_header "Hostname"
hostname

# OS
print_header "OS"
cat /etc/os-release | head -n 2


# Update
print_header "Update"
yum update | tail -n 3

# Check history command
print_header "Once check history command"
