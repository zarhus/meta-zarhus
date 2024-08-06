FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append:dbg = " file://enable-ikconfig.cfg"
SRC_URI:remove:dbg = "file://disable-ikconfig.cfg"
