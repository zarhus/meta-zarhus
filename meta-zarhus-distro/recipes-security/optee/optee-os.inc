
SUMMARY = "OP-TEE Trusted OS"
DESCRIPTION = "Open Portable Trusted Execution Environment - Trusted side of the TEE"
HOMEPAGE = "https://www.op-tee.org/"

LICENSE = "BSD-2-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173"

inherit deploy python3native
require optee.inc

CVE_PRODUCT = "linaro:op-tee op-tee:op-tee_os"

export TA_SIGN_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048.pem"
export TA_PUBLIC_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048_pub.pem"

DEPENDS:append = " python3-pyelftools-native python3-cryptography-native"
DEPENDS:append = " gcc-aarch64-none-elf-native"

DEPENDS += "python3-pycryptodome-native"
DEPENDS:append:toolchain-clang = " compiler-rt"

SRC_URI = "git://github.com/OP-TEE/optee_os.git;tag=3.20.0;protocol=https"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"

EXTRA_OEMAKE += " \
    PLATFORM=${OPTEEMACHINE} \
    CFG_${OPTEE_CORE}_core=y \
    CROSS_COMPILE_core=${HOST_PREFIX} \
    CROSS_COMPILE_ta_${OPTEE_ARCH}=${HOST_PREFIX} \
    NOWERROR=1 \
    O=${B} \
    CFG_TEE_CORE_LOG_LEVEL=4 \
    DEBUG=4 \
"
EXTRA_OEMAKE += " HOST_PREFIX=${HOST_PREFIX}"
EXTRA_OEMAKE += " CROSS_COMPILE64=${HOST_PREFIX}"
EXTRA_OEMAKE:append = " CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1"

LDFLAGS[unexport] = "1"
CPPFLAGS[unexport] = "1"
AS[unexport] = "1"
LD[unexport] = "1"

DEPENDS:append = " gcc-aarch64-none-elf-native"

EXTRA_OEMAKE:remove = " CROSS_COMPILE_core=${HOST_PREFIX}"
EXTRA_OEMAKE:remove = " CROSS_COMPILE_ta_${OPTEE_ARCH}=${HOST_PREFIX}"

EXTRA_OEMAKE:append = " CROSS_COMPILE_core=aarch64-none-elf- "
EXTRA_OEMAKE:append = " CROSS_COMPILE_ta_${OPTEE_ARCH}=aarch64-none-elf- "
EXTRA_OEMAKE:append = " CROSS_COMPILE_ta_arm64=aarch64-none-elf- "
EXTRA_OEMAKE:append = " PLATFORM=${OPTEEMACHINE} "

do_compile:prepend() {
    PLAT_LIBGCC_PATH=$(aarch64-none-elf-gcc -print-libgcc-file-name)
    export PLAT_LIBGCC_PATH
    export PLAT_LIBGCC_PATH="$(aarch64-none-elf-gcc -print-libgcc-file-name)"
}

do_compile() {
    oe_runmake -C ${S} all
}
do_compile[cleandirs] = "${B}"

do_install() {
    #install core in firmware
    install -d ${D}${nonarch_base_libdir}/firmware/
    install -m 644 ${B}/core/*.bin ${B}/core/tee.elf ${D}${nonarch_base_libdir}/firmware/

    #install tas in optee_armtz
    install -d ${D}${nonarch_base_libdir}/optee_armtz/
    install -m 444 ${B}/ta/*/*.ta ${D}${nonarch_base_libdir}/optee_armtz
}

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_deploy() {
    install -d ${DEPLOYDIR}/${MLPREFIX}optee
    install -m 644 ${D}${nonarch_base_libdir}/firmware/* ${DEPLOYDIR}/${MLPREFIX}optee

    install -d ${DEPLOYDIR}/${MLPREFIX}optee/ta
    install -m 644 ${B}/ta/*/*.elf ${DEPLOYDIR}/${MLPREFIX}optee/ta
}

addtask deploy before do_build after do_install

SYSROOT_DIRS += "${nonarch_base_libdir}/firmware"

PACKAGES += "${PN}-ta"
FILES:${PN}:append = " ${nonarch_base_libdir}/firmware/"
FILES:${PN}-ta:append = " ${nonarch_base_libdir}/optee_armtz/*"

# note: "textrel" is not triggered on all archs
INSANE_SKIP:${PN} = "textrel"
# Build paths are currently embedded
INSANE_SKIP:${PN} += "buildpaths"
INSANE_SKIP:${PN}-dev = "staticdev"
INHIBIT_PACKAGE_STRIP = "1"
