require zarhus-base-image.inc

IMAGE_FEATURES += "debug-tweaks"

IMAGE_INSTALL:append = " \
    packagegroup-zarhus-dbg \
    packagegroup-core-buildessential \
"
