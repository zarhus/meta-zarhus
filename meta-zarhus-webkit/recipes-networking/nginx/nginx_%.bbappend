FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://hello-world.html \
"

do_install:append() {
    install -m 0644 "${WORKDIR}/hello-world.html" "${D}${NGINX_WWWDIR}/html/"
    chown ${NGINX_USER}:www-data -R ${D}${NGINX_WWWDIR}
}

FILES:${PN} += " ${NGINX_WWWDIR}/*"
