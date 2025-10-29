UKI_CMDLINE:append = " \
    rd.luks.encrypt=PARTLABEL=${OTAB_LABEL_ROOTFS_A},PARTLABEL=${OTAB_LABEL_ROOTFS_B},PARTLABEL=${OTAB_LABEL_ROOTFS_OVERLAY}=no_reencrypt \
"

IMAGE_INSTALL:append = " e2fsprogs-resize2fs"
DEPENDS:append = " \
    e2fsprogs-native \
    bc-native \
    mtools-native \
"

# Change root= & rd.luks.rootfs= to second rootfs
def get_second_cmdline(d):
    import re
    cmdline = d.getVar("UKI_CMDLINE")
    cmdline = re.sub(
        r"root=.*?( |$)",
        fr"root=LABEL={d.getVar('OTAB_LABEL_ROOTFS_B')} ",
        cmdline
    )
    cmdline = re.sub(
        r"rd\.luks\.rootfs=.*?( |$)",
        fr"rd.luks.rootfs=PARTLABEL={d.getVar('OTAB_LABEL_ROOTFS_B')} ",
        cmdline
    )
    # ukify will trim multiple whitespace characters into one
    return " ".join(cmdline.split())

# Modified copy with added shrinking of partition by 32 MB before gzipping.
# nooelint: oelint.vars.spacesassignment
do_deploy_partitions() {
    part_dir="${WORKDIR}/build-wic"
    for partition in "$part_dir"/*.direct.p*; do
        partition_basename="$(basename "$partition")"
        ext="${partition_basename##*.}"
        # get p<x> from .direct.p<x>...
        rootfs_ext=$(echo "${OTAB_ROOTFS_A_IMAGE_FSTYPE}" | sed -nr 's/.*\.direct\.p([0-9])+.*/p\1/p')
        bbdebug 1 "rootfs_ext=$rootfs_ext"
        for deploy_ext in ${DEPLOY_PARTITIONS}; do
            bbdebug 1 "deploy_ext=$deploy_ext, ext=$ext"
            if [ "$deploy_ext" = "$ext" ]; then
                cp "${partition}" "${partition}-copy"
                partition="${partition}-copy"
                if [ "$ext" = "$rootfs_ext" ]; then
                    bbdebug 1 "shrinking ${partition} by 32 MB"
                    device_size="$(stat -c '%s' "${partition}")"
                    e2fsck -fp "${partition}"
                    resize2fs "${partition}" "$(echo "${device_size}/1024/1024-32" | bc)M" -f
                    e2fsck -fp "${partition}"
                fi
                bbdebug 1 "Setting label and UUID"
                set_label_and_uuid "$partition"
                bbdebug 1 "gzipping ${partition}"
                gzip --force --keep -9 "$partition"
                partition_image_basename="${IMAGE_BASENAME}-${MACHINE}.direct.$ext"
                mv "${partition}.gz" "${DEPLOY_DIR_IMAGE}/${partition_image_basename}.gz"
                rm "${partition}"
                break
            fi
        done
    done
}
