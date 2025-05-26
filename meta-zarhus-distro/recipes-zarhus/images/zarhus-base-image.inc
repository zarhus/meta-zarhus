SUMMARY = "zarhus image"
LICENSE = "MIT"

IMAGE_FEATURES += " \
    ssh-server-openssh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'splash', '', d)} \
    "

DEPENDS:append = " openssl-native"

inherit core-image extrausers

EXTRA_USERS_PARAMS:append = " useradd -p '' -mG sudo user;  passwd-expire user;"
LAYER_COMMIT_SHA = "${@get_commit_sha(d)}"

IMAGE_INSTALL:append = " \
    packagegroup-zarhus-system \
"

# This is needed so that the build has different partuuid's from different
# commits, to prevent booting from incorrect partitions
def get_commit_sha(d):
    import subprocess, os

    layerdir = d.getVar('THISDIR')
    sha = subprocess.check_output(
        ['git', '-C', layerdir, 'rev-parse', 'HEAD'],
        text=True
    ).strip()

    return sha
