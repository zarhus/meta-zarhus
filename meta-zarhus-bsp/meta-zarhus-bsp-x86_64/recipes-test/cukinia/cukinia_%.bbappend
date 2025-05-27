FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://x86_64.conf"

FILES:${PN} += " \
    ${sysconfdir}/cukinia/conf.d/x86_64.conf \
"

do_install:append() {
    install -d "${D}${sysconfdir}/cukinia/conf.d"
    install -m "0644" "${WORKDIR}/x86_64.conf" "${D}${sysconfdir}/cukinia/conf.d/"
}
