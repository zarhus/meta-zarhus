DEPLOY_PARTITIONS = "p2"

DEPENDS:append = " \
    util-linux-native \
    e2fsprogs-native \
    mtools-native \
"

do_deploy_partitions() {
    part_dir="${WORKDIR}/build-wic"
    for partition in "$part_dir"/*.direct.p*; do
        partition_basename="$(basename "$partition")"
        ext="${partition_basename##*.}"
        for deploy_ext in ${DEPLOY_PARTITIONS}; do
            if [ "$deploy_ext" = "$ext" ]; then
                cp "${partition}" "${partition}-copy"
                partition="${partition}-copy"
                bbdebug 1 "Setting label and UUID"
                set_label_and_uuid "$partition"
                bbdebug 1 "gzipping $partition"
                gzip --force --keep -9 "$partition"
                partition_image_basename="${IMAGE_BASENAME}-${MACHINE}.direct.$ext"
                mv "${partition}.gz" "${DEPLOY_DIR_IMAGE}/${partition_image_basename}.gz"
                rm "$partition"
                break
            fi
        done
    done
}

set_label_and_uuid() {
    partition="$1"
    fstype=$(blkid -o value -s TYPE "$partition")
    case "$fstype" in
    vfat)
        # mlabel requires volume ID in format xxxxyyyy, in Linux it'll be
        # XXXX-YYYY. This tool also capitalizes both label and ID
        mlabel -i "$partition" -N "${BOOT_TMP_UUID}" ::"${BOOT_TMP_LABEL}"
        ;;
    ext2 | ext3 | ext4)
        tune2fs "$partition" -L "${ROOT_TMP_LABEL}" -U "${ROOT_TMP_UUID}"
        ;;
    *)
        bbfatal "$fstype filesystem isn't supported."
        ;;
    esac
}

addtask deploy_partitions after do_image_wic before do_build
