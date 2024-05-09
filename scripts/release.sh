#!/bin/bash
#
# SPDX-FileCopyrightText: 2022 3mdeb Embedded Systems Consulting <contact@3mdeb.com>
#
# SPDX-License-Identifier: MIT

PROJECT_NAME="zarhus"
META_LAYER_NAME="meta-zarhus"
DISTRO_CONF_FILE_LOCAL="meta-zarhus-distro/conf/distro/zarhus-distro.conf"
GENERATE_OVA="false"


# Usually, we deliver layers prepared for one device (with one machine config).
# In the case of supporting more platforms, the list below should be expanded,
# for example:
# machine-1-hw-prod
# machine-1-hw-debug
# machine-2-hw-prod
# machine-2-hw-debug
function printAvailableTargets {
    echo "    Available TARGETs:"
    echo "      - hw-prod - hardware target - production image"
    echo "      - hw-debug - hardware target - debug image"
}

function targetMapping {
    local _target="$1"
    # currently only one target is supported
    if [ "$_target" = "hw-prod" ]; then
      KAS_FILE="kas-prod.yml"
      MACHINE="zarhus-machine"
      BASE_IMAGE_NAME="zarhus-base-image"
      # BASE_SWU_IMAGE_NAME="zarhus-swu-image"
    elif [ "$_target" = "hw-debug" ]; then
      KAS_FILE="kas-debug.yml"
      MACHINE="zarhus-machine"
      BASE_IMAGE_NAME="zarhus-base-image-debug"
      # BASE_SWU_IMAGE_NAME="zarhus-swu-image-debug"
    else
        echo "Invalid TARGET: $_target"
        printAvailableTargets
        exit 1
    fi
}

###############################################################################
### global consts - user-specific configuration
###############################################################################
KAS_SSH_DIR="${KAS_SSH_DIR:-}"
# If set to true, will automatically generate OVA from the produced VMDK
GENERATE_OVA="${GENERATE_OVA:-true}"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $SCRIPT_DIR/release-common.sh
