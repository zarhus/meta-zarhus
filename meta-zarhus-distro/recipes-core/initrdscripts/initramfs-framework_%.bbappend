FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://hello"

do_install:append () {
    install -m 0755 ${WORKDIR}/hello ${D}/init.d/85-hello
}

FILES:${PN}-base += "/init.d/85-hello"
