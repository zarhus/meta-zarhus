FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

require optee-client.inc

PV     = "3.20.0+git${SRCPV}"

inherit pkgconfig

COMPATIBLE_MACHINE = "raspberrypi4-64"
