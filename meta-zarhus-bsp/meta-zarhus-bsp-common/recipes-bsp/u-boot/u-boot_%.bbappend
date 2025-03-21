FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'file://${SPLASH_IMAGE}', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'file://enable-splash.cfg', '', d)} \
    "
SPLASH_IMAGE = "zarhus-logo.bmp"

do_compile:append() {
    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'yes', 'no', d)}" = "yes" ]; then
        echo "splashsource=mmc_fs" >> "${B}/u-boot-initial-env"
        echo "splashfile=/boot/${SPLASH_IMAGE}" >> "${B}/u-boot-initial-env"
    fi
}

do_install:append() {
    if [ "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'yes', 'no', d)}" = "yes" ]; then
        install -d "${D}/boot"
        install -m 0400 "${WORKDIR}/${SPLASH_IMAGE}" "${D}/boot/${SPLASH_IMAGE}"
    fi
}

FILES:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'splash', '/boot/${SPLASH_IMAGE}', '', d)}"
