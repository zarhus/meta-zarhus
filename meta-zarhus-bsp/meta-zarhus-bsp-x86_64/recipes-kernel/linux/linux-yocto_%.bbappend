FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
KMACHINE:x86-64 = "common-pc-64"

SRC_URI:append = " \
    file://enable-lockdown.cfg \
    file://enable-expert.cfg \
"
