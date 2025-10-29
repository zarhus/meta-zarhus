inherit uki uuid
EFI_PROVIDER ?= ""
IMAGE_EFI_BOOT_FILES = "${UKI_FILENAME};EFI/BOOT/bootx64.efi"
IMAGE_BOOT_FILES = "${IMAGE_EFI_BOOT_FILES}"
# Board-specific tweaks
CMDLINE_CONSOLE ?= "ttyS0,115200"
UKI_CMDLINE:x86-64 = "root=LABEL=${ROOTFS_LABEL} console=${CMDLINE_CONSOLE} quiet"
BOOT_UUID = "${@generate_uuid_from_sha(d, 'BOOT_UUID')[:8]}"
ROOT_UUID = "${@generate_uuid_from_sha(d, 'ROOT_UUID')}"

WICVARS:append = " BOOT_UUID ROOT_UUID"
