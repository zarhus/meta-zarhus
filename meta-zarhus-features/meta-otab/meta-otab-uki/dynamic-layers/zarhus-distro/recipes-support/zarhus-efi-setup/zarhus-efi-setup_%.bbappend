FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

OTAB_FILES_WITH_VARIABLES = "${D}${libdir}/zarhus/setup-efi-entry.sh"

inherit otab_variables_postinstall
