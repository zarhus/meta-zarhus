#!/bin/bash

RELEASE=$(grep '^DISTRO_VERSION ' ./meta-zarhus-distro/conf/distro/include/zarhus-distro-common.conf | cut -d'=' -f2 | tr -d ' "')
echo $RELEASE

docker run -t -v "$(pwd)":/app/ "orhunp/git-cliff:${TAG:-latest}" \
  --prepend CHANGELOG.md --unreleased --tag "$RELEASE"
