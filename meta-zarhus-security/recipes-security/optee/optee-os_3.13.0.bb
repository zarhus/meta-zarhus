require recipes-security/optee/optee-os.inc

DEPENDS:append = " dtc-native"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0003-optee-enable-clang-support.patch \
"
SRCREV = "30c13f9e2ff178c9a299e409de75d50529cf5064"

# nooelint: oelint.vars.specific
MACHINE_OPTEE_OS_REQUIRE:rk3566 = "optee-os-rk3566.inc"

require ${MACHINE_OPTEE_OS_REQUIRE}
