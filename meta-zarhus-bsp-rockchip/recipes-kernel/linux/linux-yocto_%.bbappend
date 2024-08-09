FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# reduce kernel attack surface
SRC_URI:append = " \
    file://disable-btrfs.cfg \
    file://disable-bug.cfg \
    file://disable-debug.cfg \
    file://disable-ftrace.cfg \
    file://disable-ikconfig.cfg \
    file://disable-ip-pnp.cfg \
    file://disable-kallsyms.cfg \
    file://disable-kgdb.cfg \
    file://disable-kprobes.cfg \
    file://disable-magic.cfg \
    file://disable-nfs.cfg \
    file://enable-cmdline-bool.cfg \
    file://enable-debug-stackoverflow.cfg \
"

COMPATIBLE_MACHINE:zarhus-machine-cm3 = "zarhus-machine-cm3"
