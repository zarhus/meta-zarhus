do_install:append() {
    echo 'export PATH=/usr/sbin:$PATH' >> ${D}${sysconfdir}/skel/.bashrc
}
