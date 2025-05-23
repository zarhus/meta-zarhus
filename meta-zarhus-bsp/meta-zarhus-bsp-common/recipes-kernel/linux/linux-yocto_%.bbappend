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
"

# keep some debug options for debug builds
SRC_URI:remove:dbg = " \
    file://disable-debug.cfg \
    file://disable-ikconfig.cfg \
    file://disable-kallsyms.cfg \
    file://disable-bug.cfg \
"
