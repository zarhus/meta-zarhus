# Ensure the ESP is always mounted by label, not by device path
do_install:append() {
    # Add our deterministic entry
    echo 'LABEL=zarhus-boot  /boot  vfat  defaults,noatime  0  0' \
        >> ${D}${sysconfdir}/fstab
}
