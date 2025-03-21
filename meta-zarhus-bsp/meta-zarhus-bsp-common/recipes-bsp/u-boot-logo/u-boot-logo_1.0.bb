SUMMARY = "Prepare U-Boot logo"
HOMEPAGE = "https://docs.zarhus.com"
# TODO: which license does logo have
LICENSE = "CLOSED"

DEPENDS = "imagemagick-native"

SPLASH_FILE = "logo-${PV}"
SPLASH_SOURCE = "https://docs.zarhus.com/images/zarhus-logo.svg;downloadfilename=${SPLASH_FILE}"
SRC_URI = "${SPLASH_SOURCE}"
SRC_URI[sha256sum] = "2ba3358102e2bb27b5c2b21d06e47325aa8238fad629d67ac46b97d8c77ab470"

inherit allarch

python do_prepare_logo() {
    workdir = d.getVar("WORKDIR")
    logo_size = d.getVar("LOGO_SIZE")
    resize = f"-resize {logo_size}" if logo_size else ""
    splash = d.getVar("SPLASH_FILE")
    cmd = f"magick.im7 {splash} -depth 8 -type truecolor {resize} logo.bmp"
    bb.note(f"Converting image: {cmd}")
    bb.process.run(cmd, cwd=workdir)
}

do_install() {
    install -d "${D}/boot"
    install -m 0644 "${WORKDIR}/logo.bmp" "${D}/boot/logo.bmp"
}

FILES:${PN} += "/boot/logo.bmp"

addtask prepare_logo before do_configure after do_prepare_recipe_sysroot
addtask install before do_build after do_fetch
