EXTRA_OEMAKE:append:rk3566 = " \
        BL31=${DEPLOY_DIR_IMAGE}/bl31-rk3566.elf \
        ROCKCHIP_TPL=${DEPLOY_DIR_IMAGE}/ddr-rk3566.bin \
"
INIT_FIRMWARE_DEPENDS:rk3566 = " rockchip-rkbin:do_deploy"
do_compile[depends] += "${INIT_FIRMWARE_DEPENDS}"
