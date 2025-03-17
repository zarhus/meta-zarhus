SUMMARY = "Rockchip Firmware and Tool Binaries"
HOMEPAGE = "https://gitlab.com/firefly-linux/external/security/rk_tee_user"
# No license provided, assuming closed:
LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

FILESEXTRAPATHS:prepend := "${THISDIR}/rk-tee-user:"

# The change_puk binary was downloaded from
# https://gitlab.com/firefly-linux/external/security/rk_tee_user, from commit
# 15d87232f3418b49b5b706f4a655d1d2dc384bdf. It cannot be compiled manually,
# because Rockchip does not share source code, and there is no other way to
# replace keys inside Rockchip OPTEE OS binary.
SRC_URI = "file://change_puk"

inherit_defer native

do_install() {
        install -d ${D}${bindir}
        install -m 0755 ${WORKDIR}/change_puk ${D}${bindir}
}
