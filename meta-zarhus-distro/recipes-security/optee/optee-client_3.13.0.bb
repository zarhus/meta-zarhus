FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

require optee-client.inc

SRCREV = "${AUTOREV}"
PV     = "3.13.0+git${SRCPV}"

inherit pkgconfig

COMPATIBLE_MACHINE = "raspberrypi4-64"
