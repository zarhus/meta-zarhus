# for some reason /dev/disk/by-label symlink isn't created when updating
# encrypted partition via swupdate so we have to use old one. Changing
# label via tune2fs or using 'cryptsetup refresh' works. calling
# 'udevadm trigger' doesn't
do_insert_otab_variables_preinstall:prepend() {
    sed -i -e 's@<ROOT_TMP_LABEL>@${root_label}@g' "${WORKDIR}/otab-shell"
}

# To force do_unpack to rerun
# TODO: find better way
ROOT_TMP_LABEL = '${root_label}'
