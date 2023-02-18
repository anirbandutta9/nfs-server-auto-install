#!/bin/bash

# Check if script is running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Prompt user to enter NFS directory path
read -p "Enter the path of the directory you want to export via NFS (e.g. /home/user/nfs_share): " NFS_DIR

# Create NFS directory if it doesn't exist
if [ ! -d "$NFS_DIR" ]; then
    mkdir -p "$NFS_DIR"
fi

# Prompt user to enter IP range
read -p "Enter the IP range you want to allow to access the NFS share (e.g. 192.168.1.0/24): " IP_RANGE

# Install NFS server package
apt-get update
apt-get install -y nfs-kernel-server


#set permissions on directory
chown -R nobody:nogroup "$NFS_DIR"
chmod 777 "$NFS_DIR"

# Add NFS directory to exports file
echo "$NFS_DIR $IP_RANGE(rw,sync,no_subtree_check)" >> /etc/exports

#Utilize the provided command for exporting the NFS shared directory:
exportfs -a

# Restart NFS server
systemctl restart nfs-kernel-server

echo "NFS server installation and configuration complete!"


