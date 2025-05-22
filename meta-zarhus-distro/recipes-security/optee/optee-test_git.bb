require optee-test.inc

SRCREV = "3cc6173b5812935adb071bd7b7ecfa42cb7cd2c5"
PV = "3.20.0+git${SRCPV}"

COMPATIBLE_MACHINE = "raspberrypi4-64"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-xtest-stats-remove-unneeded-stat.h-include.patch \
"

do_compile[depends] .= " keys-recipe:do_prepare_elf "

export TA_SIGN_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048.pem"
export TA_PUBLIC_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048_pub.pem"
