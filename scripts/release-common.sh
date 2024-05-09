#!/bin/bash
#
# SPDX-FileCopyrightText: 2022 3mdeb Embedded Systems Consulting <contact@3mdeb.com>
#
# SPDX-License-Identifier: MIT

function errorCheck {
    local error_code="${?}"
    if [ "${error_code}" -ne 0  ]; then
        errorExit "${1} : ${error_code}"
    fi
}

function errorExit {
    local error_message="$1"
    echo "${error_message}"
    exit 1
}

function printHelp {
    cat <<EOF
Usage: ${0} command [options]
    Commands:
         help                  print this help
         bump BUMP_LEVEL       bump the image (DISTRO) version and create git commit
                               available bump levels: major, minor, patch
         build TARGET          build and version images (for given TARGET); also place them in the \"artifacts\"
                               directory and generate the "latest.txt" file
         version TARGET        DO NOT build, only version images (for given TARGET); also place them in the \"artifacts\"
                               directory and generate the "latest.txt" file, manual build is expected priot using that command
    Options:
        -s <sdk_dir>           absolute path to the SDK directory (containing meta layers); defaults to \$PWD
    Examples:
        $0 build rpi -s \$PWD
        $0 build vbox -s \$PWD
        $0 build hw-prod -s \$PWD
        $0 bump patch -s \$PWD
EOF
    printAvailableTargets
    exit 1
}

[ $# -eq 0 ] && printHelp

OPTIND=3
while getopts ":s:" o; do
    case "${o}" in
        s)
            SDK_DIR="${OPTARG}"
            ;;
        *)
            echo "Unrecognized option: \"${o}\""
            printHelp
            ;;
        esac
done

COMMAND=$1

[ -z "${SDK_DIR}" ] && echo "SDK_DIR not given, using default value: \$PWD" && SDK_DIR="${PWD}"

###############################################################################
### global consts - do not change
###############################################################################
META_LAYER_DIR="${SDK_DIR}/${META_LAYER_NAME}"
DISTRO_CONF_FILE="${META_LAYER_DIR}/${DISTRO_CONF_FILE_LOCAL}"
META_VBOX="${SDK_DIR}/meta-vbox"

###############################################################################
### get distro version
###############################################################################
function getDistroVersion {
    DISTRO_VERSION=$(cat ${DISTRO_CONF_FILE} | grep DISTRO_VERSION | cut -d "=" -f 2 | tr -d '"' | tr -d " ")
    echo "DISTRO_VERSION read from ${DISTRO_CONF_FILE} file: ${DISTRO_VERSION}"
}

###############################################################################
### bump distro version
###############################################################################
function bumpDistroVersion {
    DISTRO_VERSION=$(cat ${DISTRO_CONF_FILE} | grep DISTRO_VERSION | cut -d "=" -f 2 | tr -d '"' | tr -d " ")
    local ver_major=$(echo ${DISTRO_VERSION} | cut -d '.' -f 1)
    local ver_minor=$(echo ${DISTRO_VERSION} | cut -d '.' -f 2)
    local ver_patch=$(echo ${DISTRO_VERSION} | cut -d '.' -f 3)

    case ${BUMP_LEVEL} in
        "patch")
            ver_patch=$((${ver_patch} + 1))
        ;;
        "minor")
            ver_minor=$((${ver_minor} + 1))
            ver_patch=0
        ;;
        "major")
            ver_major=$((${ver_major} + 1))
            ver_minor=0
            ver_patch=0
        ;;
        *)
        echo "Invalid version bump level: ${BUMP_LEVEL}"
        printHelp
        exit 1
        ;;
    esac

    DISTRO_VERSION="${ver_major}.${ver_minor}.${ver_patch}"
    sed -e "s/^DISTRO_VERSION = \".*\"$/DISTRO_VERSION = \"${DISTRO_VERSION}\"/" \
        -i ${DISTRO_CONF_FILE}

    if pushd ${META_LAYER_DIR}; then
        git add ${DISTRO_CONF_FILE}
        git commit -sm "common: distro: release ${DISTRO_VERSION}"
        popd
    fi
}

###############################################################################
### build the image
###############################################################################
function buildImages {
    which kas-container
    errorCheck "kas-container not found in PATH"

    local kas_ssh_switch=""
    if [ -n "${KAS_SSH_DIR}" ]; then
        kas_ssh_switch="--ssh-dir ${KAS_SSH_DIR}"
    fi

    echo "Building for $TARGET"
    SHELL=/bin/bash kas-container ${kas_ssh_switch} build ${META_LAYER_DIR}/$KAS_FILE
    errorCheck "Build for $TARGET failed"
}

###############################################################################
# copy and version the artifacts (disk image, bmap file, SWU image)
###############################################################################
function versionImages {
    if [ "$TARGET" = "vbox" ]; then
      IMAGE_EXTENSION="wic.vmdk"
    else
      IMAGE_EXTENSION="wic.gz"
    fi

    BMAP_EXTENSION="wic.bmap"
    SWU_IMAGE_EXTENSION="swu"
    BUILD_DIR="${SDK_DIR}/build"
    DEPLOY_DIR="${BUILD_DIR}/tmp/deploy/images/${MACHINE}"
    ARTIFACTS_DIR="${SDK_DIR}/artifacts/${TARGET}"

    IMAGE_FILE="${BASE_IMAGE_NAME}-${MACHINE}.${IMAGE_EXTENSION}"
    BMAP_FILE="${BASE_IMAGE_NAME}-${MACHINE}.${BMAP_EXTENSION}"
    SWU_FILE="${BASE_SWU_IMAGE_NAME}-${MACHINE}.${SWU_IMAGE_EXTENSION}"

    IMAGE_FILE_RENAMED="${BASE_IMAGE_NAME}-${MACHINE}-${DISTRO_VERSION}.${IMAGE_EXTENSION}"
    BMAP_FILE_RENAMED="${BASE_IMAGE_NAME}-${MACHINE}-${DISTRO_VERSION}.${BMAP_EXTENSION}"
    SWU_FILE_RENAMED="${BASE_SWU_IMAGE_NAME}-${MACHINE}-${DISTRO_VERSION}.${SWU_IMAGE_EXTENSION}"

    mkdir -p ${ARTIFACTS_DIR}
    cp ${DEPLOY_DIR}/${IMAGE_FILE} ${ARTIFACTS_DIR}/${IMAGE_FILE_RENAMED}
    # if BASE_SWU_IMAGE_NAME was not given, assume the SWU file is not built by
    # the project
    if [ -n "${BASE_SWU_IMAGE_NAME}" ]; then
        cp ${DEPLOY_DIR}/${SWU_FILE} ${ARTIFACTS_DIR}/${SWU_FILE_RENAMED}
    fi
    # we do not produce BMAP file for vbox, only for hardware platforms
    if [ "${TARGET}" != "vbox" ]; then
      cp ${DEPLOY_DIR}/${BMAP_FILE} ${ARTIFACTS_DIR}/${BMAP_FILE_RENAMED}
    else
        # optionally generate OVA for vbox TARGET
        if [ "${GENERATE_OVA}" = "true" ]; then
            VM_NAME="${PROJECT_NAME}-${DISTRO_VERSION}"
            OVA_FILE="${VM_NAME}.ova"
            ${META_VBOX}/scripts/vm-create.sh ${VM_NAME} ${ARTIFACTS_DIR}/${IMAGE_FILE_RENAMED}
            errorCheck "Failed to generate VirtualBox OVA virtual machine"
            mv ${OVA_FILE} ${ARTIFACTS_DIR}/
        fi
    fi

    # if BASE_SWU_IMAGE_NAME was not given, assume the SWU file is not built by
    # the project
    if [ -n "${BASE_SWU_IMAGE_NAME}" ]; then
        # create the latest.txt file
        LATEST_TXT="${ARTIFACTS_DIR}/latest.txt"

        echo "VERSION=\"${DISTRO_VERSION}\"" > ${LATEST_TXT}
        echo "FILE=\"${SWU_FILE_RENAMED}\"" >> ${LATEST_TXT}
    fi
}


case "${COMMAND}" in
    "bump")
        BUMP_LEVEL="$2"
        getDistroVersion
        bumpDistroVersion
        ;;
    "build")
        TARGET="$2"
        [ -z "$TARGET" ] && errorExit "TARGET not given"
        targetMapping $TARGET
        getDistroVersion
        buildImages
        versionImages
        ;;
    "version")
        TARGET="$2"
        [ -z "$TARGET" ] && errorExit "TARGET not given"
        getDistroVersion
        targetMapping $TARGET
        versionImages
        ;;
    "help")
        printHelp
        ;;
    *)
        echo "Invalid command"
        printHelp
        ;;
esac
