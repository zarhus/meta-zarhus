IMAGE_INSTALL:append = " packagegroup-zarhus-encryption"
# Add at least 512 MB of extra space (for encryption).
# To encrypt device we shrink fs by 32 MB to make space for LUKS2 header.
# resize2fs needs more extra space to shrink filesystem by that much
IMAGE_ROOTFS_EXTRA_SPACE:append = " + 524288"
UKI_CMDLINE:append = " rd.luks.rootfs=PARTLABEL=rootfs"
