FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE:append = "|odroid-h4"
KMACHINE:odroid-h4 = "common-pc-64"

SRC_URI:append = " \
    file://enable-lockdown.cfg \
    file://enable-expert.cfg \
"
