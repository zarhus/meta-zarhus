PACKAGES += " \
  ${PN}-webkit \
"

RDEPENDS:${PN}-webkit = " \
  weston \
  packagegroup-core-weston \
  weston-init \
  wayland \
  cog \
"
