do_install:append:orangepi-cm4() {
        ln -s brcmfmac43456-sdio.bin ${D}${nonarch_base_libdir}/firmware/brcm/brcmfmac43456-sdio.orangepi,cm4-base.bin
}
