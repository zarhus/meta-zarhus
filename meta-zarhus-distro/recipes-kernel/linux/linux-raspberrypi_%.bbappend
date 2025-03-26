FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KERNEL_CONFIG_FRAGMENTS += "file://optee-support.cfg"

SRC_URI:append = " file://optee-support.cfg"
