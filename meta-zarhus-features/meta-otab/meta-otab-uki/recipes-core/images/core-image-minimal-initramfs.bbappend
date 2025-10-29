BAD_RECOMMENDATIONS += "initramfs-module-rootfs"
INITRAMFS_SCRIPTS:append = " \
    initramfs-module-rorootfs-overlay \
    initramfs-module-create-partitions \
    initramfs-module-shutdown \
"
