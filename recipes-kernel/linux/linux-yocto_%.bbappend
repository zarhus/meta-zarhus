FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:dbg = " file://enable-ikconfig.cfg"
SRC_URI:remove:dbg = "file://disable-ikconfig.cfg"
SRC_URI:append = " file://add-st7701-st1633-drivers.cfg"
