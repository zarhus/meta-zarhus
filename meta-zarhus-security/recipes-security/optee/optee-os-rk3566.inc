COMPATIBLE_MACHINE = "rk3566"
OPTEEMACHINE = "rockchip"
EXTRA_OEMAKE += " PLATFORM_FLAVOR=rk3566"

SRC_URI:append =" \
    file://0001-add-rk3566-support.patch \
    file://0001-arm-kernel-link.mk-delete-fatal-warnings-fatal.patch \
"

# optee-os and optee-ta-devkit packages depend on keys created in do_prepare_elf
# task of rockchip-rkbin package:
do_compile[depends] .= " rockchip-rkbin:do_prepare_elf"
export TA_SIGN_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048.pem"
export TA_PUBLIC_KEY="${DEPLOY_DIR_IMAGE}/keys/rsa2048_pub.pem"
