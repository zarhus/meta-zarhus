SUMMARY = "zarhus packagegroup"
DESCRIPTION = "zarhus packagegroup"

LICENSE = "MIT"

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
"
