require recipes-security/optee/optee-client.inc

DEPENDS += "util-linux"
SRCREV = "7c9c423d00e96bf51debd5fe10fd70dce83be5cc"

inherit pkgconfig
# tee-supplicant can emulate RPMB, but in production image it is better to use
# real one:
EXTRA_OEMAKE:append = "PKG_CONFIG=pkg-config RPM_EMU=0"

COMPATIBLE_MACHINE:rk3566 = "rk3566"
