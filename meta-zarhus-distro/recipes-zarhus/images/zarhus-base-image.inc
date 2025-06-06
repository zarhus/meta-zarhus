SUMMARY = "zarhus image"

IMAGE_FEATURES += " \
    ssh-server-openssh \
    ${@bb.utils.contains('DISTRO_FEATURES', 'splash', 'splash', '', d)} \
    "

LICENSE = "MIT"

inherit core-image

LAYER_COMMIT_SHA = "${@get_commit_sha(d)}"

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

IMAGE_INSTALL:append = " \
    packagegroup-zarhus-system \
"
