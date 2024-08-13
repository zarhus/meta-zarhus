# Add trusted binaries for rk3566:
COMPATIBLE_MACHINE:rk3566 = "rk3566"

do_deploy:rk3566() {
        # Prebuilt TF-A
        install -m 644 ${S}/bin/rk35/rk3568_bl31_v*.elf ${DEPLOYDIR}/bl31-rk3566.elf
        # Prebuilt OPTEE-OS
        install -m 644 ${S}/bin/rk35/rk3568_bl32_v*.bin ${DEPLOYDIR}/tee-rk3566.bin
        # Prebuilt U-Boot TPL (DDR init)
        install -m 644 ${S}/bin/rk35/rk3566_ddr_1056MHz_v1.18.bin ${DEPLOYDIR}/ddr-rk3566.bin
}
