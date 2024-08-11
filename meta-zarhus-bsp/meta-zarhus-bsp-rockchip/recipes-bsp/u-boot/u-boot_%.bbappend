FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
        file://enable-optee.cfg \
        file://0001-arch-arm-dts-rk356x-add-reserved-memory-for-OP-TEE.patch \
        file://0001-orangepi-cm4-base-rk3566_defconfig-copy-from-linux-t.patch \
        "

# Link ATF compiled for rk3568 to U-Boot image fot rk3566 because the SoC's are
# identical from ATF point of view:
EXTRA_OEMAKE:append:rk3566 = " \
        BL31=${DEPLOY_DIR_IMAGE}/bl31-rk3566.elf \
        ROCKCHIP_TPL=${DEPLOY_DIR_IMAGE}/ddr-rk3566.bin \
"
INIT_FIRMWARE_DEPENDS:rk3566 = " rockchip-rkbin:do_deploy"
do_compile[depends] += "${INIT_FIRMWARE_DEPENDS}"
