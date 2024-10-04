#!/bin/bash

###################################
# 
# Author: Saurabh Kaveri
# Date: 21/03/2024
# This bash script is designed to collect various network-related information from a Linux system and dump it into a text file.
# Version: v1
####################################

IP4FW=/usr/sbin/iptables
IP6FW=/usr/sbin/ip6tables
LSPCI=/usr/bin/lspci
ROUTE=/usr/sbin/route
NETSTAT=/usr/bin/netstat
LSB=/usr/bin/lsb_release

## files ##
DNSCLIENT="/etc/resolv.conf"
DRVCONF="/etc/modprobe.conf"
NETALIASCFC="/etc/sysconfig/network-scripts/ifcfg-eth?-range?"
NETCFC="/etc/sysconfig/network-scripts/ifcfg-eth?"
NETSTATICROUTECFC="/etc/sysconfig/network-scripts/route-eth?"
SYSCTL="/etc/sysctl.conf"

## The name of the output file containing network information ##
OUTPUT="network.$(date +'%d-%m-%y').info.txt"

## Email address to which the network information will be sent ##
SUPPORT_ID="your_name@service_provider.com"

## Checks if the script is being run as root. If not, it exits with an error message ##
check_root() {

    local user=$(id -u)
    if [ $user -ne 0 ]; then
        echo "You must be a root user to run this tool"
        exit 999
    fi
}

## when you call write_header with a message as an argument, it prints the message followed by a visual separator above and below it in the output file specified by $OUTPUT. This helps in visually separating different sections of information in the output file ##
write_header() {
	echo "---------------------------------------------------" >>$OUTPUT
	echo "$@" >>$OUTPUT
	echo "---------------------------------------------------" >>$OUTPUT
}

## Dump network-related information to the output file ##
dump_info {

    echo "Hostname: $(hostname)" > "$OUTPUT"
    echo "Run date and time: $(date)" >> "$OUTPUT"

    # Write Linux distribution information
    write_header "Linux Distro"
    echo "Linux kernel version: $(uname -mrs)" >> "$OUTPUT"
    $LSB -a >> "$OUTPUT"

    # Write PCI devices information
    write_header "PCI Devices"
    $LSPCI -v >> "$OUTPUT"

}
