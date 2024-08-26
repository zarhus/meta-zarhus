FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

EXTRA_OEMAKE:append:rk3566 = " \
        BL31=${DEPLOY_DIR_IMAGE}/bl31-rk3566.elf \
        ROCKCHIP_TPL=${DEPLOY_DIR_IMAGE}/ddr-rk3566.bin \
"
INIT_FIRMWARE_DEPENDS:rk3566 = " rockchip-rkbin:do_deploy"
do_compile[depends] += "${INIT_FIRMWARE_DEPENDS}"

SRC_URI:append = " \
    file://orangepi-cm4-base-rk3566_defconfig \
    file://rk3566-orangepi-cm4-base.dts \
    file://rk3566-orangepi-cm4-base-u-boot.dtsi \
    file://rk3566-orangepi-cm4.dtsi \
    "

do_configure:prepend() {
    install -m 644 "${WORKDIR}/air-money-rk3566_defconfig" "${S}/configs"
    install -m 644 "${WORKDIR}/rk3566-air-money.dts" "${S}/arch/arm/dts"
    install -m 644 "${WORKDIR}/rk3566-air-money.dtsi" "${S}/arch/arm/dts"
    install -m 644 "${WORKDIR}/rk3566-air-money-u-boot.dtsi" "${S}/arch/arm/dts"
    echo 'dtb-$(CONFIG_ROCKCHIP_RK3568) += rk3566-air-money.dtb' >> "${S}/arch/arm/dts/Makefile"

    install -m 644 "${WORKDIR}/orangepi-cm4-base-rk3566_defconfig" "${S}/configs"
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4-base.dts" "${S}/arch/arm/dts"
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4.dtsi" "${S}/arch/arm/dts"
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4-base-u-boot.dtsi" "${S}/arch/arm/dts"
    echo 'dtb-$(CONFIG_ROCKCHIP_RK3568) += rk3566-orangepi-cm4.dtb' >> "${S}/arch/arm/dts/Makefile"
}
