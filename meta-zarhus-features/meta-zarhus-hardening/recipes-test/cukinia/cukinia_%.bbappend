FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://hardening.conf"
FILES:${PN} += "${sysconfdir}/cukinia/conf.d/*.conf"

do_install:append() {
    install -d "${D}${sysconfdir}/cukinia/conf.d"
    install -m "0644" "${WORKDIR}/hardening.conf" "${D}${sysconfdir}/cukinia/conf.d/"
}
