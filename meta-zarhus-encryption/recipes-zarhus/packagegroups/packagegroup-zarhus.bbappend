PACKAGES += "${PN}-encryption"

RDEPENDS:${PN}-encryption = " \
    systemd-crypt \
    tpm2-tools \
    tpm2-abrmd \
    tpm2-tools \
    tpm2-tss \
    libtss2 \
    libtss2-mu \
    libtss2-tcti-device \
    libtss2-tcti-mssim \
"
