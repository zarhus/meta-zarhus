FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

RDEPENDS:append:${PN}-autostart = " \
    nginx \
    "

PROVIDES:append:${PN} = " \
    ${PN}-autostart \
    "

SRC_URI:append:${PN}-autostart = " \
    file://cog-autostart.service \
    "

PACKAGES += " \
    ${PN}-autostart \
    "

inherit systemd

COG_WIDTH ?= "1920"
COG_HEIGHT ?= "1080"

SYSTEMD_AUTO_ENABLE:${PN}-autostart = "enable"
SYSTEMD_SERVICE:${PN}-autostart = "cog-autostart.service"

do_install:append:${PN}-autostart() {
    install -D -m 0644 "${WORKDIR}/cog-autostart.service" "${D}${systemd_system_unitdir}/cog-autostart.service"
    sed -i 's/COG_PLATFORM_WL_VIEW_WIDTH="[0-9]*"/COG_PLATFORM_WL_VIEW_WIDTH="${COG_WIDTH}"/' ${D}${systemd_system_unitdir}/cog-autostart.service
    sed -i 's/COG_PLATFORM_WL_VIEW_HEIGHT="[0-9]*"/COG_PLATFORM_WL_VIEW_HEIGHT="${COG_HEIGHT}"/' ${D}${systemd_system_unitdir}/cog-autostart.service

}
