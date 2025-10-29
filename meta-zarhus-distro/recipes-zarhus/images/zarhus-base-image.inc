SUMMARY = "zarhus image"
LICENSE = "MIT"

IMAGE_FEATURES += " \
    ssh-server-openssh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'splash', '', d)} \
"

inherit core-image

IMAGE_INSTALL:append = " \
    packagegroup-zarhus-system \
"
