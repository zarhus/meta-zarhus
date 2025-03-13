require optee-os.inc

DEPENDS:append = " dtc-native"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRCREV = "30c13f9e2ff178c9a299e409de75d50529cf5064"

# nooelint: oelint.vars.specific
MACHINE_OPTEE_OS_REQUIRE:raspberrypi4-64 = "optee-os-rpi4.inc"

require ${MACHINE_OPTEE_OS_REQUIRE}
