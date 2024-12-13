require tls-dir.inc

do_install:append() {
    weston_ini="${D}${sysconfdir}/xdg/weston/weston.ini"
    # remove top panel
    sed -i 's/#\[shell\]/\[shell\]/' "${weston_ini}"
    sed -i '/^\[shell\]/a panel-position=none' "${weston_ini}"
}

do_install:append:dbg() {
    # start screen share on startup
    sed -i '/^\[screen-share\]/a start-on-startup=true' "${weston_ini}"
    sed -ri "s|(--backend=rdp-backend.so)|\1 --rdp-tls-cert=${TLS_DIR}/tls.crt --rdp-tls-key=${TLS_DIR}/tls.key|" "${weston_ini}"
    sed -ri "s|(^ExecStart=.*$)|\1,screen-share.so|" "${D}${systemd_system_unitdir}/weston.service"
}
