COMPATIBLE_MACHINE = "raspberrypi4-64"
OPTEEMACHINE = "rpi4"
EXTRA_OEMAKE += " \
    PLATFORM_FLAVOR=rk3566 \
    CFG_ARM64_core=y \
    "

export TA_SIGN_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048.pem"
export TA_PUBLIC_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048_pub.pem"
