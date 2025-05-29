FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://encryption.conf"
FILES:${PN} += "${sysconfdir}/cukinia/conf.d/encryption.conf"
RDEPENDS:${PN} += " jq"

do_install:append() {
    install -d "${D}${sysconfdir}/cukinia/conf.d"
    install -m "0644" "${WORKDIR}/encryption.conf" "${D}${sysconfdir}/cukinia/conf.d/"
}
