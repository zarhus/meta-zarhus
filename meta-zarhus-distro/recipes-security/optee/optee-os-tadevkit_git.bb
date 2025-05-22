SRCREV = "d015c528ea711a1f8acf9629e1a2cbf0cb34908c"

require optee-os_git.bb

SUMMARY = "OP-TEE Trusted OS TA devkit"
DESCRIPTION = "OP-TEE TA devkit for build TAs"
HOMEPAGE = "https://www.op-tee.org/"

do_compile[depends] += "keys-recipe:do_prepare_elf"

# nooelint: oelint.task.nocopy
do_install() {
    install -d "${D}${includedir}/optee/export-user_ta"
    cp -aR "${B}/export-ta_arm64/"* \
           "${D}${includedir}/optee/export-user_ta/"
}

do_deploy() {
    echo "Do not inherit do_deploy from optee-os."
}

FILES:${PN}:append = " ${includedir}/optee/"

# Build paths are currently embedded
INSANE_SKIP:${PN}-dev += "buildpaths"

# Include extra headers needed by SPMC tests to TA DEVKIT.
# Supported after op-tee v3.20
EXTRA_OEMAKE:append = "${@bb.utils.contains('MACHINE_FEATURES', 'optee-spmc-test', \
                                        ' CFG_SPMC_TESTS=y', '' , d)}"

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

EXTRA_OEMAKE += " \
    CFG_TEE_CORE_LOG_LEVEL=4 \
    DEBUG=4 \
"
