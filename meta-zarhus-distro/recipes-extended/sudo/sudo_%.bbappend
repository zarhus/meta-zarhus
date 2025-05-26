do_install:append() {
    sed -i 's/# \(%sudo\sALL=(ALL:ALL) ALL\)/\1/' ${D}${sysconfdir}/sudoers
}
