SUMMARY = "Firmware files for use with Linux kernel"
DESCRIPTION = "A nice source of firmwares not present in linux-firmware repo"
HOMEPAGE = "https://github.com/armbian/firmware/tree/master"
SECTION = "kernel"

LICENSE = "CLOSED"

SRC_URI = "git://github.com/armbian/firmware.git;branch=master;protocol=https"

SRCREV = "511deee7289cb9a5dee6ba142d18a09933d5ba00"

S = "${WORKDIR}/git"

inherit allarch

CLEANBROKEN = "1"

do_compile() {
    :
}

do_install() {
    install -d 0755 ${D}${nonarch_base_libdir}/firmware/brcm

    install -m 0644 ${S}/brcm/brcmfmac43456-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm
    install -m 0644 ${S}/brcm/brcmfmac43456-sdio.clm_blob ${D}${nonarch_base_libdir}/firmware/brcm
    install -m 0644 ${S}/brcm/brcmfmac43456-sdio.txt ${D}${nonarch_base_libdir}/firmware/brcm

    install -m 0644 ${S}/brcm/BCM4345C5.hcd ${D}${nonarch_base_libdir}/firmware/brcm
}

PACKAGES =+ " \
             ${PN}-bcm4345c5 \
             ${PN}-bcm43456 \
             "

FILES:${PN}-bcm4345c5 += "${nonarch_base_libdir}/firmware/brcm/BCM4345C5.hcd"
FILES:${PN}-bcm43456 += "${nonarch_base_libdir}/firmware/brcm/brcmfmac43456-sdio.*"
