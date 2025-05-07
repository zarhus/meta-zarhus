# Skip contrib/pzstd for the native build – we don’t need it
do_compile:class-native() {
    oe_runmake -C lib      ${PARALLEL_MAKE}
    oe_runmake -C programs ${PARALLEL_MAKE} zstd-release
}

# …and don’t try to install it either
do_install:class-native() {
    oe_runmake DESTDIR="${D}" PREFIX="${prefix}" -C lib      install
    oe_runmake DESTDIR="${D}" PREFIX="${prefix}" -C programs install
}
