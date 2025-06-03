FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
DEPENDS += "imagemagick-native"
SPLASH_STEM = "logo-${PV}"
SPLASH_FILE = "${SPLASH_STEM}.png"
# nooelint: oelint.vars.mispell # codespell:ignore
SPLASH_IMAGES = "https://docs.zarhus.com/images/zarhus-logo.svg;name=logo;downloadfilename=${SPLASH_FILE}"
SRC_URI[logo.sha256sum] = "2ba3358102e2bb27b5c2b21d06e47325aa8238fad629d67ac46b97d8c77ab470"
SRC_URI += "file://fb.rules"

python do_prepare_logo() {
    workdir = d.getVar("WORKDIR")
    logo_size = d.getVar("LOGO_SIZE")
    resize = f"-resize {logo_size}" if logo_size else ""
    splash = d.getVar("SPLASH_FILE")
    cmd = f"magick.im7 {splash} {resize} {splash}"
    bb.note(f"Converting to png: {cmd}")
    bb.process.run(cmd, cwd=workdir)
}

do_install:append() {
    ln -rs "${D}${bindir}/psplash-${SPLASH_STEM}" "${D}${bindir}/psplash"
    install -d "${D}${sysconfdir}/udev/rules.d/"
    install -m 644 "${WORKDIR}/fb.rules" "${D}${sysconfdir}/udev/rules.d/fb.rules"
    sed -i '/\[Unit\]/a BindsTo=dev-fb0.device' "${D}${systemd_system_unitdir}/psplash-start.service"
    sed -i '/\[Unit\]/a After=dev-fb0.device' "${D}${systemd_system_unitdir}/psplash-start.service"
}

FILES:${PN} += "${sysconfdir}/udev/rules.d/fb.rules"

addtask prepare_logo before do_configure after do_prepare_recipe_sysroot
