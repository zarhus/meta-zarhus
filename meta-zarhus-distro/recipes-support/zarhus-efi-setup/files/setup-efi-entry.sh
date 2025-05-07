#!/bin/sh
set -e

# Delete the entry that was used to boot this session
efibootmgr -b "$(efibootmgr | head -1 | awk '{print $2}')" -B

# Delete all EFI boot entries labeled "ZarhusOS"
efibootmgr | grep "ZarhusOS" | awk '{print $1}' | sed 's/Boot//;s/\*//' | while read -r bootnum; do
    efibootmgr -b "$bootnum" -B
done

# Create the stable ZarhusOS entry on the disk
DISK=$(lsblk -no PKNAME "$(findmnt -nr -o SOURCE /boot)")
efibootmgr --disk "/dev/$DISK" \
           --part 1 \
           --create \
           --label "ZarhusOS" \
           --loader '\EFI\BOOT\bootx64.efi'
