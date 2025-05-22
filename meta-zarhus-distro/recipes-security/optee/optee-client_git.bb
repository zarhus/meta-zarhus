FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRCREV = "3eac340a781c00ccd61b151b0e9c22a8c6e9f9f0"

require optee-client.inc

PV = "3.20.0+git${SRCPV}"

inherit pkgconfig

COMPATIBLE_MACHINE = "raspberrypi4-64"

EXTRA_OEMAKE:append = " WITH_TEEACL=0"
