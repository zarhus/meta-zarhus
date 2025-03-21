FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'imagemagick-native', '', d)}"
# mmc 1 partition 9
DEVPART = "1:9"
LOAD_ADDR = "\$loadaddr"
SRC_URI += "\
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'file://enable-splash.cfg', '', d)} \
    "

# For some reason it doesn't run this recipe
RDEPENDS:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'u-boot-logo', '', d)}"

do_configure:append() {
    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'yes', 'no', d)}" = "yes" ]; then
        sed -i '/#define ENV_MEM_LAYOUT_SETTINGS\s*\\/a "splashsource=mmc_fs\\0" \\' "${S}/include/configs/rk3568_common.h"
        sed -i '/#define ENV_MEM_LAYOUT_SETTINGS\s*\\/a "splashfile=/boot/logo.bmp\\0" \\' "${S}/include/configs/rk3568_common.h"
        sed -i "/#define ENV_MEM_LAYOUT_SETTINGS\s*\\\\/a \"splashimage=${LOAD_ADDR}\\\\0\" \\\\" "${S}/include/configs/rk3568_common.h"
        sed -i "/#define ENV_MEM_LAYOUT_SETTINGS\s*\\\\/a \"splashdevpart=${DEVPART}\\\\0\" \\\\" "${S}/include/configs/rk3568_common.h"
    fi
}
