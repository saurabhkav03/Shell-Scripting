#!/bin/bash

# Paths to commands and files
IP4FW="/sbin/iptables"
IP6FW="/sbin/ip6tables"
LSPCI="/usr/bin/lspci"
ROUTE="/sbin/route"
NETSTAT="/bin/netstat"
LSB="/usr/bin/lsb_release"

# Files and output
DNSCLIENT="/etc/resolv.conf"
DRVCONF="/etc/modprobe.conf"
NETCFC="/etc/sysconfig/network-scripts/ifcfg-eth?"
NETSTATICROUTECFC="/etc/sysconfig/network-scripts/route-eth?"
SYSCTL="/etc/sysctl.conf"
OUTPUT="network.$(date +'%d-%m-%y').info.txt"
SUPPORT_ID="your_name@service_provider.com"

# Check if the user is root
chk_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "You must be root user to run this tool"
        exit 1
    fi
}

# Write a header to the output file
write_header() {
    echo "---------------------------------------------------" >> "$OUTPUT"
    echo "$@" >> "$OUTPUT"
    echo "---------------------------------------------------" >> "$OUTPUT"
}

# Dump network-related information to the output file
dump_info() {
    echo "* Hostname: $(hostname)" > "$OUTPUT"
    echo "* Run date and time: $(date)" >> "$OUTPUT"

    # Write Linux distribution information
    write_header "Linux Distro"
    echo "Linux kernel: $(uname -mrs)" >> "$OUTPUT"
    $LSB -a >> "$OUTPUT"

    # Write PCI devices information
    write_header "PCI Devices"
    $LSPCI -v >> "$OUTPUT"

    # Write network configuration file information
    write_header "Network Configuration File"
    for f in $NETCFC; do
        if [ -f "$f" ]; then
            echo "** $f **" >> "$OUTPUT"
            cat "$f" >> "$OUTPUT"
        else
            echo "Error $f not found." >> "$OUTPUT"
        fi
    done

    # Write network static routing configuration information
    write_header "Network Static Routing Configuration"
    for f in $NETSTATICROUTECFC; do
        if [ -f "$f" ]; then
            echo "** $f **" >> "$OUTPUT"
            cat "$f" >> "$OUTPUT"
        else
            echo "Error $f not found." >> "$OUTPUT"
        fi
    done

    # Write firewall configurations
    write_header "IP4 Firewall Configuration"
    $IP4FW -L -n >> "$OUTPUT"

    write_header "IP6 Firewall Configuration"
    $IP6FW -L -n >> "$OUTPUT"

    # Write network statistics
    write_header "Network Stats"
    $NETSTAT -s >> "$OUTPUT"

    # Write network tweaks via sysctl.conf
    write_header "Network Tweaks via $SYSCTL"
    [ -f "$SYSCTL" ] && cat "$SYSCTL" >> "$OUTPUT" || echo "Error $SYSCTL not found." >> "$OUTPUT"

    # Final message
    echo "The Network Configuration Info Written To $OUTPUT. Please email this file to $SUPPORT_ID."
}

# Main execution
chk_root
dump_info
