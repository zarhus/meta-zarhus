FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
SRC_URI += " \
    file://enable-bmp.cfg \
    file://virtio_gpu-driver-and-relevant-fix.patch \
    file://0001-common-board_r.c-add-virtio_init-to-init_sequence_r.patch \
    "
