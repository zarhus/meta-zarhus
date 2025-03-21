require optee-os.inc

DEPENDS:append = " dtc-native"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRCREV = "${AUTOREV}"

# nooelint: oelint.vars.specific
MACHINE_OPTEE_OS_REQUIRE:raspberrypi4-64 = "optee-os-rpi4.inc"

require ${MACHINE_OPTEE_OS_REQUIRE}
