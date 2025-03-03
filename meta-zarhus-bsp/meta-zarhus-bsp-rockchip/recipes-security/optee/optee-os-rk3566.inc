FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

COMPATIBLE_MACHINE = "rk3566"
OPTEEMACHINE = "rockchip"
EXTRA_OEMAKE += " PLATFORM_FLAVOR=rk3566 DEBUG=4 CFG_TEE_TA_LOG_LEVEL=4 CFG_TEE_CORE_LOG_LEVEL=4"

SRC_URI:append =" \
    file://0001-core-arch-arm-plat-rockchip-add-rk3566-support.patch \
"
