inherit cargo

SUMMARY = "A utility for mapping events from Linux event devices."
HOMEPAGE = "https://github.com/KarsMulder/evsieve"
LICENSE = "GPL-2.0-or-later"
LIC_FILES_CHKSUM = "file://LICENSE;md5=b234ee4d69f5fce4486a80fdaf4a4263"

DEPENDS:append = " libevdev"

SRC_URI:append = " \
                   git://github.com/KarsMulder/evsieve.git;protocol=https;branch=main \
                   crate://crates.io/lazy_static/1.4.0 \
                   crate://crates.io/libc/0.2.82 \
                   "

SRC_URI[lazy_static-1.4.0.sha256sum] = "e2abad23fbc42b3700f2f279844dc832adb2b2eb069b2df918f455c4e18cc646"
SRC_URI[libc-0.2.82.sha256sum] = "89203f3fba0a3795506acaad8ebce3c80c0af93f994d5a1d7a0b1eeb23271929"

SRCREV = "162839865e85c65cfc6d4591218e1320378bf079"
S = "${WORKDIR}/git"
