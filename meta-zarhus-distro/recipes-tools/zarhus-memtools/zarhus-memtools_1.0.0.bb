SUMMARY = "Tools for measuring and analyzing memory usage of a process"
HOMEPAGE = "https://docs.zarhus.com"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "\
    file://mem_usage \
    file://mem_test \
    file://plot_mem_usage.py \
    "

S = "${WORKDIR}"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/mem_test ${D}${bindir}
    install -m 0755 ${S}/plot_mem_usage.py ${D}${bindir}
    install -m 0755 ${S}/mem_usage ${D}${bindir}
}

FILES:${PN} += " \
    ${bindir}/mem_usage \
    ${bindir}/mem_test \
    ${bindir}/plot_mem_usage.py \
    "

RDEPENDS:${PN} += "bash"
