FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
    echo 'efivarfs /sys/firmware/efi/efivars efivarfs rw,nosuid,nodev,noexec,nofail 0 0' \
        >> ${D}${sysconfdir}/fstab
    # add `,ro` to /boot partition mount options (4th column)
    awk -i inplace '/\/boot\s/ {$4=$4 ",ro"; print $0; next} 1' ${D}${sysconfdir}/fstab
}
