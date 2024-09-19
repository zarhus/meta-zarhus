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
    file://0001-rk356x.dtsi-add-optee-firmware-entry.patch \
    file://0001-rk356x.dtsi-reserve-optee-memory.patch \
"

SRC_URI:append = " \
    file://rk3566-orangepi-cm4.dtsi \
    file://rk3566-orangepi-cm4-base.dts \
"

do_configure:append() {
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4-base.dts" "${S}/${DTS_DIR}"
    install -m 644 "${WORKDIR}/rk3566-orangepi-cm4.dtsi" "${S}/${DTS_DIR}"
    echo 'dtb-$(CONFIG_ARCH_ROCKCHIP) += rk3566-orangepi-cm4.dtb' >> "${S}/${DTS_DIR}/Makefile"
}

COMPATIBLE_MACHINE:orangepi-cm4 = "orangepi-cm4"
COMPATIBLE_MACHINE:zarhus-machine-cm3 = "zarhus-machine-cm3"
