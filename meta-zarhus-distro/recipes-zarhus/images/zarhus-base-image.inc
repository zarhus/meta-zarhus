SUMMARY = "zarhus image"

IMAGE_FEATURES += " ssh-server-openssh"
IMAGE_FEATURES:dbg += " debug-tweaks"

LICENSE = "MIT"

inherit core-image

IMAGE_INSTALL:append = " \
    packagegroup-zarhus-system \
"

IMAGE_INSTALL:append:dbg = " \
    packagegroup-zarhus-dbg \
"
