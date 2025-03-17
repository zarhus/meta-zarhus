FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# rockchip-rkbin provides OPTEE OS tee-rk3566.elf:
DEPENDS += " rockchip-rkbin"

SRC_URI += " \
    file://enable-optee.cfg \
    file://optee.dtsi \
"

EXTRA_OEMAKE:append:rk3566 = " \
    BL31=${DEPLOY_DIR_IMAGE}/bl31-rk3566.elf \
    ROCKCHIP_TPL=${DEPLOY_DIR_IMAGE}/ddr-rk3566.bin \
    TEE=${DEPLOY_DIR_IMAGE}/tee-rk3566.elf \
"

do_configure:prepend() {
    install -m 644 "${WORKDIR}/optee.dtsi" "${S}/arch/arm/dts"
}
