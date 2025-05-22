SRCREV = "3cc6173b5812935adb071bd7b7ecfa42cb7cd2c5"

require optee-test.inc

PV = "3.20.0+git${SRCPV}"

COMPATIBLE_MACHINE = "raspberrypi4-64"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-xtest-stats-remove-unneeded-stat.h-include.patch \
"

do_compile[depends] .= " keys-recipe:do_prepare_elf "

CFLAGS += " -O2"

EXTRA_OEMAKE:append = " \
    ARCH=aarch64 \
    PLATFORM_FLAVOR=qemu_armv8a \
    CFG_TA_OPTEE_CORE_API_COMPAT_1_1=y \
    DEBUG=0 \
    CFG_TEE_TA_LOG_LEVEL=0 \
    CFG_PKCS11_TA=n \
"
