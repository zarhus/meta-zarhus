SUMMARY = "Example MbedTLS applications"
HOMEPAGE = "https://github.com/3mdeb/MbedTLS_services"
SECTION = "tools"

LICENSE = "CLOSED"
LIC_FILES_CHKSUM = ""

SRC_URI = "git://git@github.com/3mdeb/MbedTLS_services.git;protocol=ssh;branch=self-generated-keys"
SRCREV = "b09d661518d11cc82848efba6d74109362c43c1c"

S = "${WORKDIR}/git"

DEPENDS:append = " mbedtls"

RDEPENDS:${PN} = " \
    mbedtls \
"

do_configure[noexec] = "1"

export LDFLAGS += " -lmbedcrypto -lmbedtls -lmbedx509 -O0 -g3"
export CXXFLAGS += " -std=c++11 -Wall -Wextra -O0 -g3"

do_compile () {
    oe_runmake mbedtls_script_ca
    oe_runmake mbedtls_script_peer
}

do_install () {
    oe_runmake install DESTDIR="${D}"
}
