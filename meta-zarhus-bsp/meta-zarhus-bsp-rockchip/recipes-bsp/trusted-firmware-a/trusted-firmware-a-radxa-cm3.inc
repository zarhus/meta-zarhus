# Radxa CM3 specific TF-A:
COMPATIBLE_MACHINE:rk3566 = "rk3566"

# There is no configuration files available for rk3566 in TFA source code, so
# rk3568 is boing used, because it has only differences in some interfaces and
# power controll, which seems to not be critical for TFA.
TFA_PLATFORM:rk3566 = "rk3568"

TFA_SPD = "opteed"
TFA_DEBUG = "1"
#TFA_UBOOT = "1"
TFA_BUILD_TARGET = "bl31"
