FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

KERNEL_CONFIG_FRAGMENTS += "file://optee-support.cfg"

SRC_URI:append = " file://optee-support.cfg"
SRC_URI:append = " file://0001-CROSSCON-Hypervisor-OP-TEE-and-enclave-support-v6.patch"
SRC_URI:append = " file://0002-Add-ipc-driver-v6.patch"
