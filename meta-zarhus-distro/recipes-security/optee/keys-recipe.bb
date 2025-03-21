SUMMARY = "Generate dev RSA keys for OP-TEE TA signing"
LICENSE = "CLOSED"

PN = "keys-recipe"

inherit native
DEPENDS = "openssl-native"

KEYS_DIRECTORY = "${DEPLOY_DIR_IMAGE}/keys"

do_configure() {
    :
}

do_prepare_elf() {
    echo "==> Generating dev RSA keys in ${KEYS_DIRECTORY} ..."
    install -d ${KEYS_DIRECTORY}
    openssl genrsa -out ${KEYS_DIRECTORY}/rsa2048.pem 2048
    openssl rsa    -in ${KEYS_DIRECTORY}/rsa2048.pem -pubout \
                   -out ${KEYS_DIRECTORY}/rsa2048_pub.pem
    echo "==> Done generating dev RSA keys."
}

addtask prepare_elf before do_build after do_configure

do_install() {
    :
}

FILES:${PN} = ""
