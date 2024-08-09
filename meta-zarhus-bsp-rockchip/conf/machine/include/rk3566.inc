MACHINEOVERRIDES =. "rk3566:"

SOC_FAMILY = "rk3566"

DEFAULTTUNE ?= "cortexa55"

require conf/machine/include/soc-family.inc
require conf/machine/include/arm/armv8-2a/tune-cortexa55.inc
require conf/machine/include/rockchip-defaults.inc
require conf/machine/include/rockchip-wic.inc

KBUILD_DEFCONFIG ?= "defconfig"
KERNEL_FEATURES:append:rk3566 = " bsp/rockchip/remove-non-rockchip-arch-arm64.scc"
KERNEL_CLASSES = "kernel-fitimage"
KERNEL_IMAGETYPE ?= "fitImage"

PREFERRED_PROVIDER:trusted-firmware-a = "rockchip-rkbin"
PREFERRED_PROVIDER:optee-os = "rockchip-rkbin"

UBOOT_SUFFIX ?= "itb"
UBOOT_ENTRYPOINT ?= "0x06000000"
