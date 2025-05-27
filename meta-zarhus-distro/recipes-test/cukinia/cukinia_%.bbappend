FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# nooelint: oelint.append.protvars.LICENSE
LICENSE = "Apache-2.0"
# nooelint: oelint.append.protvars.LIC_FILES_CHKSUM
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"
# nooelint: oelint.append.protvars.PV
PV = "0.7.0"

SRC_URI += " \
    file://cukinia.conf \
    file://distro.conf \
"

# nooelint: oelint.append.protvars.SRCREV
SRCREV = "be56f653743cc0e68bef81ef35df7c50ff8919c4"

FILES:${PN} += " \
    ${sysconfdir}/cukinia/cukinia.conf \
    ${sysconfdir}/cukinia/conf.d/distro.conf \
"

do_install:append() {
    install -d "${D}${sysconfdir}/cukinia/conf.d"
    install -m "0644" "${WORKDIR}/cukinia.conf" "${D}${sysconfdir}/cukinia/cukinia.conf"
    install -m "0644" "${WORKDIR}/distro.conf" "${D}${sysconfdir}/cukinia/conf.d/"
}
