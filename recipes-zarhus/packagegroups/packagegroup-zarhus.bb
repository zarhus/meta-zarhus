SUMMARY = "zarhus packagegroup"
DESCRIPTION = "zarhus packagegroup"

LICENSE = "MIT"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = " \
    ${PN}-system \
    ${PN}-dbg \
"

RDEPENDS:${PN}-system = " \
    packagegroup-core-base-utils \
    chrony \
    chronyc \
"

RDEPENDS:${PN}-dbg = " \
    gzip \
    libgpiod \
    libgpiod-tools \
    devmem2 \
"
