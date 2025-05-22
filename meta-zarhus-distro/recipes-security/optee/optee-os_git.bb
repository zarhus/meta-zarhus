require optee-os.inc

DEPENDS:append = " dtc-native"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-add-rpi4-support.patch \
"

SRCREV = "d015c528ea711a1f8acf9629e1a2cbf0cb34908c"

# nooelint: oelint.vars.specific
MACHINE_OPTEE_OS_REQUIRE:raspberrypi4-64 = "optee-os-rpi4.inc"

require ${MACHINE_OPTEE_OS_REQUIRE}
