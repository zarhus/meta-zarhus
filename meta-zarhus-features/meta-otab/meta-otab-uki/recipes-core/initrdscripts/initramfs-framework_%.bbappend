FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://create_partitions"
PACKAGES += "initramfs-module-create-partitions"

# nooelint: oelint.var.order.SUMMARY
SUMMARY:initramfs-module-create-partitions = "initramfs support for creating partitions for slot B and overlay during first boot"
# nooelint: oelint.var.filesoverride
FILES:initramfs-module-create-partitions = "/init.d/06-create_partitions"
RDEPENDS:initramfs-module-create-partitions = " \
    ${PN}-base \
    util-linux-lsblk \
    util-linux-fdisk \
    e2fsprogs-mke2fs \
    e2fsprogs-tune2fs \
    binutils \
    mtools \
    dosfstools \
"

inherit otab_variables_postinstall
OTAB_FILES_WITH_VARIABLES:append = " ${D}/init.d/06-create_partitions"

do_install:append () {
    install -m 0755 "${WORKDIR}/create_partitions" "${D}/init.d/06-create_partitions"
}
