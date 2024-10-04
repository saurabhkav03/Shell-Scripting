#!/bin/bash

# Prompt user to provide the directory to backup
echo " "
echo "Provide full path of the directory you want to  backup of: "
read directory

# Check if directory is provided and exists
if [ -z "$directory" ] || [ ! -d "$directory" ]; then
    echo " "
    echo "Provide a valid directory path"
    exit 1
else
    echo " "
    echo "The size of the directory $directory which you want to take backup of: $(du -sh "$directory")"
fi

echo " "

# Prompt user to provide the backup directory
echo "Provide backup directory where you want to store backups:"
read backup

# Check if backup directory is provided and exists
if [ -z "$backup" ] || [ ! -d "$backup" ]; then
    echo " "
    echo "Provide a valid directory path"
    exit 1
else
    # Create backup directory with timestamp
    backup_directory="backup_$(date '+%d-%m-%y_%H:%M:%S')"
    mkdir "$backup/$backup_directory" || exit 1
fi

# Take backup using rsync
yum install rsync -y  # This line assumes you're on a system using yum package manager. Adjust accordingly.
rsync -azv "$directory/" "$backup/$backup_directory"

echo " "
#echo "Backup complete!!!"
echo " "


###Rotation
