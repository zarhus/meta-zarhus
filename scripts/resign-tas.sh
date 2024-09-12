#!/bin/bash
#
# Dependencies:
# * Repo github.com/OP-TEE/optee_os for sign_encrypt.py sccript;
# * openssl tools and libraries;
# * base64 tool;
#
# Key generation:
#    openssl genrsa -out rsa2048.pem 2048
#    openssl rsa -in rsa2048.pem -pubout -out rsa2048_pub.pem
#
# Manual instructions:
# https://optee.readthedocs.io/en/latest/building/trusted_applications.html#offline-signing-of-tas

declare PRINT_HELP
declare SCRIPT_PATH
declare PRIVATE_KEY
declare PUBLIC_KEY
declare TA
declare TA_DIR
declare TA_UUID

print_help(){
  echo "$0 [args] [ta]"
  echo "    Resign TA (or TAs), Signed TA will be placed beside unsigned one."
  echo "[args]:"
  echo "    -h, --help: Print help and exit."
  echo "    -s, --script-path [path]: Path to OP-TEE sign_encrypt.py."
  echo "    -r, --private-key [path]: Path to private key."
  echo "    -u, --public-key [path]: Path to public key."
  echo "[ta]:"
  echo "    A path to a TA in format .stripped.elf."
  echo "    A paths to TAs in format .stripped.elf."
}

generate_digest(){
  local _uuid
  local _dir
  _uuid=$2
  _dir=$1

  $SCRIPT_PATH digest --key $PUBLIC_KEY --uuid $_uuid --in $_dir/$_uuid.stripped.elf --dig $_dir/$_uuid.dig 

  return 0
}

sign_digest(){
  local _uuid
  local _dir
  _uuid=$2
  _dir=$1

  base64 --decode $_dir/$_uuid.dig | \
	  openssl pkeyutl -sign -inkey $PRIVATE_KEY \
	  -pkeyopt digest:sha256 -pkeyopt rsa_padding_mode:pss \
	  -pkeyopt rsa_pss_saltlen:digest -pkeyopt rsa_mgf1_md:sha256 | \
	  base64 > $_dir/$_uuid.sig

  return 0
}

embed_signature(){
  local _uuid
  local _dir
  _uuid=$2
  _dir=$1

  $SCRIPT_PATH stitch --key $PUBLIC_KEY --uuid $_uuid \
	  --in $_dir/$_uuid.stripped.elf --sig $_dir/$_uuid.sig --out $_dir/$_uuid.ta

  return 0
}

# Parse args:
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      PRINT_HELP="true"
      break
      ;;
    -s|--script-path)
      SCRIPT_PATH="$2"
      shift 2
      ;;
    -r|--private-key)
      PRIVATE_KEY="$2"
      shift 2
      ;;
    -u|--public-key)
      PUBLIC_KEY="$2"
      shift 2
      ;;
    *)
      # Other argoments are assummed as TA paths
      break
      ;;
  esac
done

# Print help and exit:
[ -n "$PRINT_HELP" ] && print_help && exit 0

# Check all important vars:
[ -z "$SCRIPT_PATH" ] && echo "ERROR: No path to OP-TEE sign_encrypt.py script." && exit 1
[ -z "$PRIVATE_KEY" ] && echo "ERROR: No private key provided." && exit 1
[ -z "$PUBLIC_KEY" ] && echo "ERROR: No public key provided." && exit 1

# Do work:
while [[ $# -gt 0 ]]; do
  TA="$1"

  file "$TA" || echo "ERROR: $TA does not exist." || exit 2

  TA_DIR="$(dirname $TA)"
  TA_UUID="$(basename $TA)"
  TA_UUID="${TA_UUID%%.*}"

  generate_digest $TA_DIR $TA_UUID
  sign_digest $TA_DIR $TA_UUID
  embed_signature $TA_DIR $TA_UUID

  shift 
done

exit 0
