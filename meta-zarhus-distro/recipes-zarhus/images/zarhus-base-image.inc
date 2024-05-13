DESCRIPTION = "zarhus image"

IMAGE_FEATURES += "ssh-server-openssh"

LICENSE = "MIT"

inherit core-image

IMAGE_INSTALL:append = " \
  packagegroup-zarhus-system \
"
