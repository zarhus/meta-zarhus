require recipes-bsp/trusted-firmware-a/trusted-firmware-a.inc

# Use master, because currently there is no support for rk3566/rk3568 in
# releases:
SRCREV_tfa = "765963334dca75417f6bf5e6a10d7a1717408a50"
SRCBRANCH = "master"
LIC_FILES_CHKSUM += "file://docs/license.rst;md5=b5fbfdeb6855162dded31fadcd5d4dc5"

# Radxa CM3 specific TF-A:
MACHINE_TFA_REQUIRE:rk3566 = "trusted-firmware-a-radxa-cm3.inc"

require ${MACHINE_TFA_REQUIRE}
