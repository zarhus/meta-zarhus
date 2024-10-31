PACKAGES += " \
    ${PN}-webkit \
    ${PN}-net \
"

RDEPENDS:${PN}-webkit = " \
    weston \
    packagegroup-core-weston \
    weston-init \
    wayland \
    cog \
"
RDEPENDS:${PN}-net = " \
    nginx \
"
