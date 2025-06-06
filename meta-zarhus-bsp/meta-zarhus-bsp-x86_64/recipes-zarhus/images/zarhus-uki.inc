inherit uki

# Generic defaults
UKI_CMDLINE ?= "root=LABEL=rootfs rootwait quiet"
UKI_FILENAME ?= "zarhus.efi"
EFI_PROVIDER ?= ""
IMAGE_EFI_BOOT_FILES ?= "${UKI_FILENAME};EFI/BOOT/bootx64.efi"
IMAGE_BOOT_FILES ?= "${IMAGE_EFI_BOOT_FILES}"

# Board-specific tweaks
UKI_CMDLINE:odroid-h4 = "root=LABEL=rootfs rootwait console=ttyS0,115200 quiet"

BOOT_UUID = "${@generate_uuid_from_sha(d, 'boot')}"
ROOT_UUID = "${@generate_uuid_from_sha(d, 'root')}"

def generate_uuid_from_sha(d, prefix):
    import hashlib, uuid

    sha = d.getVar('LAYER_COMMIT_SHA')
    return str(uuid.UUID(hashlib.md5((prefix + sha).encode()).hexdigest()))

WICVARS:append = " BOOT_UUID ROOT_UUID"
