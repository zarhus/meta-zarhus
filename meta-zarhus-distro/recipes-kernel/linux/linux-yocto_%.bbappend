FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
DEPENDS += "${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'imagemagick-native', '', d)}"

SPLASH_FILE = "logo-${PV}"
SPLASH_SOURCE = "https://docs.zarhus.com/images/zarhus-logo.svg"

SRC_URI:append = " file://enable-uinput.cfg"
SRC_URI:append:dbg = " file://enable-ikconfig.cfg"
SRC_URI:remove:dbg = " \
    file://disable-ikconfig.cfg \
    file://disable-debug.cfg \
    "
SRC_URI += " \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', '${SPLASH_SOURCE};name=logo;downloadfilename=${SPLASH_FILE}', '', d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'file://enable-logo.cfg', '', d)} \
    "
SRC_URI[logo.sha256sum] = "2ba3358102e2bb27b5c2b21d06e47325aa8238fad629d67ac46b97d8c77ab470"

python do_prepare_logo() {
    if not bb.utils.contains('DISTRO_FEATURES', 'splash', True, False, d):
        return
    workdir = d.getVar("WORKDIR")
    s = d.getVar("S")
    logo_size = d.getVar("LOGO_SIZE")
    resize = f"-resize {logo_size}" if logo_size else ""
    splash = d.getVar("SPLASH_FILE")
    cmd_to_png = f"magick.im7 {splash} -alpha off {resize} logo.png"
    cmd_to_ppm = f"magick.im7 logo.png -colors 224 -depth 8 -compress none logo.ppm"
    bb.note(f"Converting to png: {cmd_to_png}")
    bb.process.run(cmd_to_png, cwd=workdir)
    bb.note(f"Converting to ppm: {cmd_to_ppm}")
    bb.process.run(cmd_to_ppm, cwd=workdir)
    bb.note(f"Copying {workdir}/logo.ppm to {s}/drivers/video/logo/logo_linux_clut224.ppm")
    ret = bb.utils.copyfile(
        f"{workdir}/logo.ppm",
        f"{s}/drivers/video/logo/logo_linux_clut224.ppm"
    )
    if not ret:
        raise IOError(f"Couldn't copy {workdir}/logo.ppm to {s}/drivers/video/logo/logo_linux_clut224.ppm")
}

addtask prepare_logo before do_configure after do_kernel_checkout do_prepare_recipe_sysroot
