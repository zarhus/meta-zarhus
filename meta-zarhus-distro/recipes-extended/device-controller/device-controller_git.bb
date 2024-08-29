SUMMARY = "Device controller"
HOMEPAGE = "https://github.com/zarhus/device-controller"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${GO_SRC}/LICENSE;md5=bb56f2b415874b66f722adcee1efe324"

CONTROLLER_CONFIG_DIR = "${sysconfdir}/device-controller"

DEPENDS = "swig-native"

GO_EXTRA_LDFLAGS = "-X main.configDirPath=${CONTROLLER_CONFIG_DIR}"
GO_IMPORT = "github.com/zarhus/device-controller"
GO_SRC = "${S}/src/${GO_IMPORT}"

SRC_URI = "git://${GO_IMPORT}.git;branch=${BRANCH};protocol=ssh"
BRANCH = "device-controller"
SRCREV = "3a2c6816396d901fdf1b72c1e507d7041ed73c70"

FILES:${PN} += "/usr/local/bin ${CONTROLLER_CONFIG_DIR}"

inherit go-mod

do_compile:prepend() {
    oe_runmake prepare
}

do_install:append() {
    install -d "${D}${CONTROLLER_CONFIG_DIR}"
    install -m 0644 "${GO_SRC}/config/"* "${D}/${CONTROLLER_CONFIG_DIR}/"
}
