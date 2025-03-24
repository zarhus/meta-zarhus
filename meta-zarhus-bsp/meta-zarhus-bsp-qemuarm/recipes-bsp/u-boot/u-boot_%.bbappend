FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
LOAD_ADDR ?= "0x40200000"
# virtio 0 partition 8
DEVPART ?= "0:8"
SRC_URI += " \
    file://enable-bmp-and-virtio-gpu.cfg \
    file://virtio_gpu-driver-and-relevant-fix.patch \
    file://0001-common-board_r.c-add-virtio_init-to-init_sequence_r.patch \
    file://0001-virtio_gpu-remove-DM_FLAG_ACTIVE_DMA-to-keep-splash.patch \
    file://0001-board-qemu-arm.c-Add-virtio-splash-location.patch \
    "

do_configure:append() {
    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'yes', 'no', d)}" = "yes" ]; then
        qemu_arm_env="${S}/board/emulation/qemu-arm/qemu-arm.env"
        grep -qxF 'splashsource=virtio_fs' "${qemu_arm_env}" || echo 'splashsource=virtio_fs' >>"${qemu_arm_env}"
        grep -qxF 'splashfile=/boot/logo.bmp' "${qemu_arm_env}" || echo 'splashfile=/boot/logo.bmp' >>"${qemu_arm_env}"
        grep -qxF "splashimage=${LOAD_ADDR}" "${qemu_arm_env}" || echo "splashimage=${LOAD_ADDR}" >>"${qemu_arm_env}"
        grep -qxF "splashdevpart=${DEVPART}" "${qemu_arm_env}" || echo "splashdevpart=${DEVPART}" >>"${qemu_arm_env}"
        sed -i -e "s/stdout=serial,vidconsole/stdout=serial/g" -e "s/stderr=serial,vidconsole/stderr=serial/g" "${qemu_arm_env}"
    fi
}
