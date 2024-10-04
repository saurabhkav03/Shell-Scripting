
############################
## Author: Saurabh Kaveri
## Date: 21-04-2024
## 
## Version: 0.1
## This script consists of all the required steps for creating template
##############################


#!/bin/bash

os=$(cat /etc/os-release | head -n 1 | awk -F '=' '{print $2}' | sed 's/"//g')

if [ "$os" = "AlmaLinux" ] || [ "$os" = "CentOS Linux" ] || [ "$os" = "Oracle Linux Server" ]; then
    # Install required packages
    sudo dnf install wget net-tools gnupg2 unzip qemu-guest-agent curl -y

    # Enable and start rc-local
    sudo systemctl enable rc-local
    sudo systemctl start rc-local
    sudo chmod +x /etc/rc.d/rc.local
    
    # Add Label in fstab
    sudo e2label /dev/vda1 root
    echo "LABEL=Root / ext4 defaults 0 0" >> /etc/fstab

    # Disable Firewall and SELinux
    sudo systemctl stop firewalld
    sudo systemctl disable firewalld
    sudo sed -i 's/^SELINUX=enforcing$/SELINUX=disabled/' /etc/selinux/config
   # sudo setenforce 0

    # Disable resolvconf service
    sudo systemctl stop resolvconf
    sudo systemctl disable resolvconf

    # Edit GRUB Configuration
    sudo sed -i 's/^GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/' /etc/default/grub
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg

    # Update OS
    sudo dnf update -y

    # Remove extra kernel
    sudo dnf remove --oldinstallonly --setopt installonly_limit=2 kernel -y

    # Empty log files in /var/log
    sudo truncate --size 0 /var/log/*
    sudo truncate --size 0 /var/log/messages

    # Remove Logs and History
    sudo cat /dev/null > /root/.bash_history
    history -c
    echo " "
    echo "####################################################################################################"
    echo " "
    echo " Check the status must be active and must have execute permission for all"
    sudo systemctl status rc-local | head -n 5
    ls -ltr /etc/rc.d/rc.local
    echo " "
    echo " Check is this entry present in fstab file LABEL=root / ext4 defaults 0 0"
    cat /etc/fstab | tail -n 4
    echo " "
    echo "Firewall service must be inactive"
    sudo systemctl status firewalld | head -n 4
    echo " "
    echo ""
    cat /etc/selinux/config | grep SELINUX
    echo " "
    echo " Check the resolvconf status must be inactive"
    sudo systemctl status resolvconf
    echo " "
    echo "Check GRUB_CMDLINE_LINUX=net.ifnames=0 biosdevname=0 entry is present in /etc/default/grub file"
    cat /etc/default/grub | grep GRUB_CMDLINE_LINUX
    echo ""
    echo "cat /var/log/messages entries:"
    cat /var/log/messages
    echo " "
    echo " "
    echo " Now delete the script file and clear the history "
    echo " "
    echo " ###################################################################################################"
    echo " "
    echo " "

elif [ "$os" = "Ubuntu" ]; 
then 
    echo "The os is ubuntu"
else
    echo "The other os"
fi
