OTAB_ROOTFS_PART_SIZE ?= "2G"
DEPLOY_PARTITIONS = "p1 p2"

IMAGE_INSTALL:append = " initramfs-shutdown"
