SRCREV = "d015c528ea711a1f8acf9629e1a2cbf0cb34908c"

require optee-os.inc

DEPENDS:append = " dtc-native"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# nooelint: oelint.vars.specific
MACHINE_OPTEE_OS_REQUIRE:raspberrypi4-64 = "optee-os-rpi4.inc"

CFLAGS += "-Wno-cast-function-type"

EXTRA_OEMAKE:append = " \
    PLATFORM=rpi4 \
    ARCH=arm \
    CFG_PKCS11_TA=y \
    CFG_SHMEM_START=0x08000000 \
    CFG_SHMEM_SIZE=0x00200000 \
    CFG_CORE_DYN_SHM=n \
    CFG_NUM_THREADS=1 \
    CFG_CORE_RESERVED_SHM=y \
    CFG_CORE_ASYNC_NOTIF=n \
    CFG_TZDRAM_SIZE=0x00F00000 \
    CFG_TZDRAM_START=0x10100000 \
    CFG_GIC=y \
    CFG_ARM_GICV2=y \
    CFG_CORE_IRQ_IS_NATIVE_INTR=n \
    CFG_ARM64_core=y \
    CFG_USER_TA_TARGETS=ta_arm64 \
    CFG_DT=n \
    CFG_CORE_ASLR=n \
    CFG_CORE_WORKAROUND_SPECTRE_BP=n \
    CFG_CORE_WORKAROUND_NSITR_CACHE_PRIME=n \
    CFG_TEE_CORE_LOG_LEVEL=1 \
    DEBUG=1 -j16 \
"

require ${MACHINE_OPTEE_OS_REQUIRE}
