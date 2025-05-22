SUMMARY = "OP-TEE Xtest (sanity testsuite)"
DESCRIPTION = "Open Portable Trusted Execution Environment (OP-TEE) test suite"
HOMEPAGE = "https://github.com/crosscon/optee_test"
LICENSE = "BSD-2-Clause & GPL-2.0-only"
LIC_FILES_CHKSUM = "file://LICENSE.md;md5=daa2bcccc666345ab8940aab1315a4fa"

inherit python3native ptest
inherit deploy
require optee.inc

DEPENDS:append = " gcc-aarch64-none-elf-native"
DEPENDS:append = " optee-client optee-os-tadevkit python3-cryptography-native openssl"

SRC_URI = " \
    git://github.com/crosscon/optee_test.git;protocol=https \
    file://run-ptest \
"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

# Cmake flags taken from rpi4-ws README.md
EXTRA_OEMAKE += " \
    TA_DEV_KIT_DIR=${STAGING_INCDIR}/optee/export-user_ta \
    TEEC_EXPORT=${STAGING_DIR_HOST}${prefix} \
    OPTEE_CLIENT_EXPORT=${STAGING_DIR_HOST}${prefix} \
    CROSS_COMPILE_HOST=${HOST_PREFIX} \
    CROSS_COMPILE_TA=aarch64-none-elf- \
    O=${B} \
"

CFLAGS += "-Wno-error=deprecated-declarations"

do_compile() {
    export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1
    cd ${S}
    oe_runmake xtest
    oe_runmake ta
    oe_runmake test_plugin
}

do_compile[cleandirs] = "${B}"

do_install () {
    install -D -p -m0755 ${B}/xtest/xtest \
        ${D}${bindir}/xtest

    install -d ${D}${nonarch_base_libdir}/optee_armtz/
    install -D -p -m0444 ${B}/ta/*/*.ta \
        ${D}${nonarch_base_libdir}/optee_armtz/

    install -d ${D}${libdir}/tee-supplicant/plugins
    install -D -p -m0444 ${B}/supp_plugin/*.plugin \
        ${D}${libdir}/tee-supplicant/plugins/
}

do_deploy () {
    install -d ${DEPLOYDIR}/${MLPREFIX}optee/ta
    install -m 644 ${B}/ta/*/*.elf \
        ${DEPLOYDIR}/${MLPREFIX}optee/ta
}

do_configure:prepend() {
    export PATH="${STAGING_BINDIR_NATIVE}:$PATH"
}

addtask deploy before do_build after do_install

PACKAGE_ARCH = "${MACHINE_ARCH}"

FILES:${PN} += " \
    ${nonarch_base_libdir}/optee_armtz/ \
    ${libdir}/tee-supplicant/plugins/ \
"
