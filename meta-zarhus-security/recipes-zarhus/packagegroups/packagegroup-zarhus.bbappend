PACKAGES += " \
    ${PN}-security \
"

RDEPENDS:${PN}-dbg += " \
    optee-test \
"

# Though OPTEE OS binary is supplied by rockchip-rkbin package (check U-Boot
# DEPENDS), optee-os-ta package provide TAs, that are needed for Secure Storage
# feature, so it should be included:
RDEPENDS:${PN}-security = " \
    opensc \
    rockchip-rkbin \
    optee-os-ta \
    optee-client \
"
