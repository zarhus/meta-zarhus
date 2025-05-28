FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://encrypt_decrypt"
PACKAGES += "initramfs-module-encrypt-decrypt"

# nooelint: oelint.var.order.SUMMARY
SUMMARY:initramfs-module-encrypt-decrypt = "initramfs support for encrypting/decrypting with TPM"
# nooelint: oelint.var.filesoverride
FILES:initramfs-module-encrypt-decrypt = "/init.d/07-encrypt_decrypt"
RDEPENDS:initramfs-module-encrypt-decrypt = " \
    ${PN}-base \
    util-linux-lsblk \
    e2fsprogs-e2fsck \
    e2fsprogs-resize2fs \
    cryptsetup \
    systemd-crypt \
    tpm2-tools \
    tpm2-abrmd \
    tpm2-tss \
    libtss2 \
    libtss2-mu \
    libtss2-tcti-device \
    libtss2-tcti-mssim \
"

# which pcrs to use when enrolling TPM e.g. "1,2,7,11"
TPM_PCRS = "7"

do_install:append () {
    install -m 0755 "${WORKDIR}/encrypt_decrypt" "${D}/init.d/07-encrypt_decrypt"
    sed -i "s/<PCRS>/${TPM_PCRS}/" "${D}/init.d/07-encrypt_decrypt"
}
