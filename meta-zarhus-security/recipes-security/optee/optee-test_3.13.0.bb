require recipes-security/optee/optee-test.inc

DEPENDS:append = " python3-pycryptodome-native"

SRC_URI:append = " file://0001-xtest-stats-remove-unneeded-stat.h-include.patch"
SRCREV = "21b347a3d75fd52fd49130e75c962c5b56123d2f"

# Include ffa_spmc test group if the SPMC test is enabled.
# Supported after op-tee v3.20
EXTRA_OEMAKE:append = "${@bb.utils.contains('MACHINE_FEATURES', 'optee-spmc-test', \
                                        ' CFG_SPMC_TESTS=y CFG_SECURE_PARTITION=y', '' , d)}"

RDEPENDS:${PN} += "${@bb.utils.contains('MACHINE_FEATURES', 'optee-spmc-test', \
                                              ' arm-ffa-user', '' , d)}"

COMPATIBLE_MACHINE:rk3566 = "rk3566"

# optee-test package depend on keys created in do_prepare_elf task of
# rockchip-rkbin package:
do_compile[depends] .= " rockchip-rkbin:do_prepare_elf"
export TA_SIGN_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048.pem"
export TA_PUBLIC_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048_pub.pem"
