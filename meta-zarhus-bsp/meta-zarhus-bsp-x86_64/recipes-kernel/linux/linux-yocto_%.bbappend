FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE:append = "|odroid-h4"
KMACHINE:odroid-h4 = "common-pc-64"

# reduce kernel attack surface
SRC_URI:append = " \
    file://enable-lockdown.cfg \
"
