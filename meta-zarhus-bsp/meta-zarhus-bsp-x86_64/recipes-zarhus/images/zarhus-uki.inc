inherit uki

UKI_CMDLINE:odroid-h4 = "root=LABEL=rootfs rootwait console=ttyS0,115200 quiet"
UKI_FILENAME:odroid-h4 = "zarhus.efi"

EFI_PROVIDER:odroid-h4 = ""

IMAGE_EFI_BOOT_FILES:odroid-h4 = "${UKI_FILENAME};EFI/BOOT/bootx64.efi"
IMAGE_BOOT_FILES:odroid-h4 = "${IMAGE_EFI_BOOT_FILES}"

BOOT_UUID = "${@generate_uuid_from_sha(d, 'boot')}"
ROOT_UUID = "${@generate_uuid_from_sha(d, 'root')}"

def generate_uuid_from_sha(d, prefix):
    import hashlib, uuid

    sha = d.getVar('LAYER_COMMIT_SHA')
    return str(uuid.UUID(hashlib.md5((prefix + sha).encode()).hexdigest()))

WICVARS:append = " BOOT_UUID ROOT_UUID"
