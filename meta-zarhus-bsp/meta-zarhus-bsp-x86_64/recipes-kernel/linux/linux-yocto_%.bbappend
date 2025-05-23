FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
KMACHINE:x86-64 = "common-pc-64"

# reduce kernel attack surface
SRC_URI:append = " \
    file://enable-lockdown.cfg \
"
