require optee-os_${PV}.bb

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
