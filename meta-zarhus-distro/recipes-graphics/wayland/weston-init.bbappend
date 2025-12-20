FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://generate-rdp-tls-keys.service"

do_install:append() {
    if [ "${@bb.utils.contains('PACKAGECONFIG', 'rdp', 'yes', 'no', d)}" = "yes" ]; then
        tls_dir="${sysconfdir}/freerdp/keys"
        weston_ini="${D}${sysconfdir}/xdg/weston/weston.ini"

        # start screen share on startup
        sed -i '/^\[screen-share\]/a start-on-startup=true' "${weston_ini}"
        sed -ri "s|(--backend=rdp-backend.so)|\1 --rdp-tls-cert=${tls_dir}/tls.crt --rdp-tls-key=${tls_dir}/tls.key|" "${weston_ini}"
        sed -ri "s|(^ExecStart=.*$)|\1,screen-share.so|" "${D}${systemd_system_unitdir}/weston.service"
    fi
    install -m 0644 "${WORKDIR}/generate-rdp-tls-keys.service" "${D}${systemd_system_unitdir}/"
}

SYSTEMD_PACKAGES:append = " ${PACKAGES}"
SYSTEMD_SERVICE:${PN}-rdp += "generate-rdp-tls-keys.service"

PACKAGECONFIG:dbg += "rdp"
PACKAGECONFIG[rdp] = ",,,, ${PN}-rdp"
PACKAGES += "${PN}-rdp"

FILES:${PN}-rdp += "${systemd_system_unitdir}/generate-rdp-tls-keys.service"
