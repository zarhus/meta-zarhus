FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# reduce kernel attack surface
SRC_URI:append = " \
    file://disable-btrfs.cfg \
    file://disable-bug.cfg \
    file://disable-debug.cfg \
    file://disable-ftrace.cfg \
    file://disable-ikconfig.cfg \
    file://disable-ip-pnp.cfg \
    file://disable-kallsyms.cfg \
    file://disable-kgdb.cfg \
    file://disable-kprobes.cfg \
    file://disable-magic.cfg \
    file://disable-nfs.cfg \
    file://enable-cmdline-bool.cfg \
    file://enable-debug-stackoverflow.cfg \
"

SRC_URI:append = " \
    file://rk3566-orangepi-cm4.dtsi \
    file://rk3566-orangepi-cm4-base.dts \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'file://framebuffer.dtsi', '', d)} \
"

do_configure:append() {
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4-base.dts" "${S}/arch/arm64/boot/dts/rockchip/"
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4.dtsi" "${S}/arch/arm64/boot/dts/rockchip/"
    echo 'dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3566-orangepi-cm4.dtb' >> "${S}/arch/arm64/boot/dts/rockchip/Makefile"
    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'yes', 'no', d)}" = "yes" ]; then
        cat "${WORKDIR}/framebuffer.dtsi" >> "${S}/arch/arm64/boot/dts/rockchip/rk3566-radxa-cm3-io.dts"
    fi
}

COMPATIBLE_MACHINE:orangepi-cm4 = "orangepi-cm4"
COMPATIBLE_MACHINE:radxa-cm3 = "radxa-cm3"
