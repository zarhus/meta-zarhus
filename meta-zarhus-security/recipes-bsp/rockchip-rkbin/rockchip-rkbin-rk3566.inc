# Add trusted binaries for rk3566:
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE = "rk3566"

DEPENDS:append = " openssl-native rk-tee-user-native binutils-cross-aarch64"

SRC_URI:append = " file://optee.ld"

# Without this line build will fail with following error:
#
# ERROR: Multiple .bb files are due to be built which each provide optee-os
#   /work/meta-rockchip/recipes-bsp/rkbin/rockchip-rkbin_git.bb
#   /work/meta-arm/meta-arm/recipes-security/optee/optee-os_4.1.0.bb
#
# This happens because both packages provide OPTEE OS, but only Rockchip binary
# of OPTEE OS from rockchip-rkbin is being used in here. Even if optee-os
# package is not included into build explicitly it is being pulled in by
# optee-os-ta or optee-os-tadevkit, hence causing this error.
# One of the ways to solve this is to make an imge to depend not on optee-os but
# directly on rockchip-rkbin, and remove optee-os from rockchip-rkbin:
PROVIDES:remove = "optee-os"

KEYS_DIRECTORY="${DEPLOY_DIR_IMAGE}/keys"

do_prepare_elf() {
        install -d ${KEYS_DIRECTORY}
        # Generate key:
        openssl genrsa -out ${KEYS_DIRECTORY}/rsa2048.pem 2048
        openssl rsa -in ${KEYS_DIRECTORY}/rsa2048.pem -pubout -out ${KEYS_DIRECTORY}/rsa2048_pub.pem

        # Embed key into OPTEE OS binary:
        install ${S}/bin/rk35/rk3568_bl32_v*.bin ${WORKDIR}/
        change_puk --teebin ${WORKDIR}/rk3568_bl32_v*.bin --key ${KEYS_DIRECTORY}/rsa2048_pub.pem

        # Create final .elf file:
        cp ${WORKDIR}/rk3568_bl32_v*.bin ${WORKDIR}/tee-rk3566.bin
        aarch64-zarhus-linux-objcopy -B aarch64 -I binary -O elf64-littleaarch64 ${WORKDIR}/tee-rk3566.bin ${WORKDIR}/tee-rk3566.o
        # The 0x08400000 is from here:
        # https://github.com/rockchip-linux/rkbin/blob/0f8ac860f0479da56a1decae207ddc99e289f2e2/RKTRUST/RK3566TRUST_ULTRA.ini#L13
        aarch64-zarhus-linux-ld --entry=0x08400000 ${WORKDIR}/tee-rk3566.o -T ${WORKDIR}/optee.ld -o ${WORKDIR}/tee-rk3566.elf
}

# do_prepare_elf depends on rkbin repository (from do_unpack) and some tools
# from do_prepare_recipe_sysroot. do_configure depends on both of these tasks,
# so do_prepare_elf can depend on it:
addtask do_prepare_elf before do_deploy after do_configure

do_deploy:rk3566() {
        # Prebuilt TF-A
        install -m 644 ${S}/bin/rk35/rk3568_bl31_v*.elf ${DEPLOYDIR}/bl31-rk3566.elf
        # Prebuilt OPTEE-OS
        install -m 644 ${WORKDIR}/tee-rk3566.elf ${DEPLOYDIR}/
        # Prebuilt U-Boot TPL (DDR init)
        install -m 644 ${S}/bin/rk35/rk3566_ddr_1056MHz_v1.18.bin ${DEPLOYDIR}/ddr-rk3566.bin
}
