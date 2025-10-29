inherit uuid
# Needs to be the same as in zarhus-base-image otherwise it'll use values from
# local.conf. If it ever gets out of sync, then update will result in updated
# partition changing it's UUID.
BOOT_A_UUID = "${@generate_uuid_from_sha(d, 'BOOT_A_UUID')[:8]}"
ROOT_A_UUID = "${@generate_uuid_from_sha(d, 'ROOT_A_UUID')}"
BOOT_B_UUID = "${@generate_uuid_from_sha(d, 'BOOT_B_UUID')[:8]}"
ROOT_B_UUID = "${@generate_uuid_from_sha(d, 'ROOT_B_UUID')}"

IMAGE_BASENAME:dbg = "${PN}-debug"
OTAB_ROOTFS_IMAGE_NAME = "zarhus-base-image"
OTAB_ROOTFS_IMAGE_NAME:dbg = "zarhus-base-image-debug"
OTAB_SWUPDATE_IMAGES = "${OTAB_ROOTFS_IMAGE_NAME}"

require recipes-otab/images/otab-image.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

python () {
    image_name = d.getVar('OTAB_ROOTFS_IMAGE_NAME', True)
    image_fstype = d.getVar('OTAB_BOOT_A_IMAGE_FSTYPE', True)
    d.setVarFlag('SWUPDATE_IMAGES_FSTYPES', image_name, image_fstype)
    image_fstype = d.getVar('OTAB_ROOTFS_A_IMAGE_FSTYPE', True)
    d.appendVarFlag('SWUPDATE_IMAGES_FSTYPES', image_name, f" {image_fstype}")

    image_name = d.getVar('OTAB_KERNEL_IMAGE_TYPE', True) + '-' + d.getVar('MACHINE', True)
    d.delVarFlag('SWUPDATE_IMAGES_FSTYPES', image_name)
}

# So do_insert_otab_variables works on fresh files. Consider changing it so it
# doesn't modify files in place but creates modified ones, that way we would
# only have to rerun do_insert_otab_variables
do_unpack[vardeps] = " \
    IMAGE_BASENAME \
    OTAB_ROOTFS_IMAGE_NAME \
    OTAB_LABEL_ROOTFS_A \
    OTAB_LABEL_BOOT_A \
    BOOT_A_UUID \
    ROOT_A_UUID \
    OTAB_LABEL_ROOTFS_B \
    OTAB_LABEL_BOOT_B \
    BOOT_B_UUID \
    ROOT_B_UUID \
    BOOT_TMP_LABEL \
    ROOT_TMP_LABEL \
"
