SUMMARY = "Tools for measuring and analyzing memory usage of a process"
HOMEPAGE = "https://docs.zarhus.com"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=5a6917ac6c34ca9b935f702e32987df1"

SRC_URI = "\
    file://mem_usage \
    file://mem_test \
    file://plot_mem_usage.py \
    file://LICENSE \
    file://heap_analyze \
    "

S = "${WORKDIR}"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/mem_test ${D}${bindir}
    install -m 0755 ${S}/plot_mem_usage.py ${D}${bindir}
    install -m 0755 ${S}/mem_usage ${D}${bindir}
    install -m 0755 ${S}/heap_analyze ${D}${bindir}
}

FILES:${PN} += " \
    ${bindir}/mem_usage \
    ${bindir}/mem_test \
    ${bindir}/plot_mem_usage.py \
    ${bindir}/heap_analyze \
    "

RDEPENDS:${PN} += "bash"
