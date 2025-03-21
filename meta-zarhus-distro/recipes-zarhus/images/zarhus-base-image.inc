SUMMARY = "zarhus image"

IMAGE_FEATURES += " \
    ssh-server-openssh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'splash', '', d)} \
    "

LICENSE = "MIT"

inherit core-image

IMAGE_INSTALL:append = " \
    packagegroup-zarhus-system \
"
