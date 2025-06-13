SUMMARY = "One-shot systemd service that registers the ZarhusOS UEFI entry"
DESCRIPTION = "Systemd service that manages boot entries for Zarhus on x86-64"
HOMEPAGE = "https://docs.zarhus.com/"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

COMPATIBLE_MACHINE = "^genericx86-64$"

SRC_URI = " \
    file://setup-efi-entry.sh \
    file://zarhus-efi-setup.service \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "zarhus-efi-setup.service"

do_install() {
    # script
    install -d  ${D}${libdir}/zarhus
    install -m 0755 ${WORKDIR}/setup-efi-entry.sh  ${D}${libdir}/zarhus/

    # service unit
    install -d  ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/zarhus-efi-setup.service \
                    ${D}${systemd_system_unitdir}/
}

FILES:${PN} += " \
    ${libdir}/zarhus/ \
    ${systemd_system_unitdir}/zarhus-efi-setup.service \
"

RDEPENDS:${PN} += "efibootmgr"
