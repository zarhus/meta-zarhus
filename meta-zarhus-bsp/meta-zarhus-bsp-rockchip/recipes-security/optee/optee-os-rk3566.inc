FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE = "rk3566"
OPTEEMACHINE = "rockchip"
EXTRA_OEMAKE += " PLATFORM_FLAVOR=rk3566"

SRC_URI:append =" \
    file://0001-core-arch-arm-plat-rockchip-add-rk3566-support.patch \
"
