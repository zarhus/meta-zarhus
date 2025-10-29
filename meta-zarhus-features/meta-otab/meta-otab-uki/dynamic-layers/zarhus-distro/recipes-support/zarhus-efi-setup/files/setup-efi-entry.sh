#!/bin/sh
set -e

current_bootnum="$(efibootmgr | head -1 | awk '{print $2}')"
# Delete the entry that was used to boot this session
efibootmgr -b "$current_bootnum" -B

# Delete all EFI boot entries labeled "ZarhusOS"
efibootmgr | grep "ZarhusOS" | awk '{print $1}' | sed 's/Boot//;s/\*//' | while read -r bootnum; do
    efibootmgr -b "$bootnum" -B
done

# Create the stable ZarhusOS entry on the disk
DISK=$(lsblk -no PKNAME "$(findmnt -nr -o SOURCE /boot)")

part_a=$(realpath "/dev/disk/by-partlabel/<OTAB_LABEL_BOOT_A>")
part_a=$(printf '%s' "$part_a" | tail -c 1)
part_b=$(realpath "/dev/disk/by-partlabel/<OTAB_LABEL_BOOT_B>")
part_b=$(printf '%s' "$part_b" | tail -c 1)

efibootmgr --disk "/dev/$DISK" \
           --part "${part_a}" \
           --create \
           --label "ZarhusOS A" \
           --loader '\EFI\BOOT\bootx64.efi' \
           --index 0 \
           --bootnum "$current_bootnum"

efibootmgr --disk "/dev/$DISK" \
           --part "${part_b}" \
           --create \
           --label "ZarhusOS B" \
           --loader '\EFI\BOOT\bootx64.efi' \
           --index 1
