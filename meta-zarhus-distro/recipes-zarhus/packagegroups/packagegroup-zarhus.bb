SUMMARY = "zarhus packagegroup"
DESCRIPTION = "zarhus packagegroup"

LICENSE = "MIT"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = " \
    ${PN}-system \
    ${PN}-dbg \
    ${PN}-alsa \
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
    libdrm-tests \
"

# FIXME:
# 1. Do we need all of these?
# 2. Apparently, alsa-mixer needed the dialog and ncurses, if that is the case,
# it should be fixed in the upstream alsa recipe.

RDEPENDS:${PN}-alsa = " \
    alsa-utils-speakertest \
    alsa-utils \
    alsa-plugins \
    alsa-lib \
    alsa-tools \
    libasound \
    mpg123 \
    gettext \
    dialog \
    ncurses \
"
