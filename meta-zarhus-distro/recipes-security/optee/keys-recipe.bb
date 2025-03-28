SUMMARY = "Install a fixed dev RSA key for OP-TEE TA signing"
LICENSE = "CLOSED"

PN = "keys-recipe"

inherit native
DEPENDS = "openssl-native"

SRC_URI = "file://default_ta.pem"

KEYS_DIRECTORY = "${DEPLOY_DIR_IMAGE}/keys"

do_configure() {
    :
}

do_prepare_elf() {
    echo "==> Installing fixed dev RSA key into ${KEYS_DIRECTORY} ..."
    install -d ${KEYS_DIRECTORY}

    # Copy the key from crosscon/optee_os/optee-rpi4/export-ta_arm64/keys/default_ta.pem
    install -m 0644 ${WORKDIR}/default_ta.pem ${KEYS_DIRECTORY}/rsa2048.pem

    openssl rsa \
        -in ${KEYS_DIRECTORY}/rsa2048.pem \
        -pubout \
        -out ${KEYS_DIRECTORY}/rsa2048_pub.pem

    echo "==> Done installing fixed dev RSA keys."
}

addtask prepare_elf before do_build after do_configure

do_install() {
    :
}

FILES:${PN} = ""
