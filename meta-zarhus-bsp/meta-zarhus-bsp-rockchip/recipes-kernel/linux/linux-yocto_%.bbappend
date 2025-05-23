FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

FRAMEBUFFER_ADDR = "ee000000"
FRAMEBUFFER_MEM_SIZE = "a00000"
FRAMEBUFFER_WIDTH = "480"
FRAMEBUFFER_HEIGHT = "640"
FRAMEBUFFER_DEPTH = "4"

SRC_URI:append = " \
    file://enable-debug-stackoverflow.cfg \
    file://rk3566-orangepi-cm4.dtsi \
    file://rk3566-orangepi-cm4-base.dts \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'file://framebuffer.dtsi', '', d)} \
"

SRC_URI:append:quartz64-a = " \
    file://quartz64a-eth-enable.cfg \
"

replace_framebuffer_variables() {
    sed -e "s/@FRAMEBUFFER_ADDR/@${FRAMEBUFFER_ADDR}/g" \
        -e "s/FRAMEBUFFER_ADDR/0x${FRAMEBUFFER_ADDR}/g" \
        -e "s/FRAMEBUFFER_MEM_SIZE/0x${FRAMEBUFFER_MEM_SIZE}/g" \
        -e "s/FRAMEBUFFER_WIDTH/${FRAMEBUFFER_WIDTH}/g" \
        -e "s/FRAMEBUFFER_HEIGHT/${FRAMEBUFFER_HEIGHT}/g" \
        -e "s/FRAMEBUFFER_DEPTH/${FRAMEBUFFER_DEPTH}/g" \
        "${WORKDIR}/framebuffer.dtsi"
}

do_configure:append() {
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4-base.dts" "${S}/arch/arm64/boot/dts/rockchip/"
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4.dtsi" "${S}/arch/arm64/boot/dts/rockchip/"
    echo 'dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3566-orangepi-cm4.dtb' >> "${S}/arch/arm64/boot/dts/rockchip/Makefile"
    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'yes', 'no', d)}" = "yes" ]; then
        replace_framebuffer_variables >> "${S}/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3-io.dts"
    fi
}

COMPATIBLE_MACHINE:orangepi-cm4 = "orangepi-cm4"
COMPATIBLE_MACHINE:radxa-cm3 = "radxa-cm3"
COMPATIBLE_MACHINE:quartz64-a = "quartz64-a"
