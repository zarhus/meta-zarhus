# for some reason RDEPENDS doesn't work in u-boot. Also for some reason
# there is no do_install task
RDEPENDS:${PN} += "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'u-boot-logo', '', d)}"

do_install:append() {
    echo 'export PATH=/usr/sbin:$PATH' >> ${D}${sysconfdir}/skel/.bashrc
}
