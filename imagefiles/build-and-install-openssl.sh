#!/usr/bin/env bash
#
# Configure, build and install OpenSSL
#
# Usage:
#
#  build-and-install-openssl.sh [-32]
#
# Options:
#
#  -32              Build OpenSSL as a 32-bit library
#
# Notes:
#
#  * build directory is /usr/src/openssl-$OPENSSL_VERSION
#
#  * install directory is /usr
#
#  * after installation, build directory and archive are removed
#

set -ex
set -o pipefail

WRAPPER=""
CONFIG_FLAG=""

while [ $# -gt 0 ]; do
  case "$1" in
    -32)
      WRAPPER="linux32"
      CONFIG_FLAG="-m32"
      ;;
    *)
      echo "Usage: Usage: ${0##*/} [-32]"
      exit 1
      ;;
  esac
  shift
done

MY_DIR=$(dirname "${BASH_SOURCE[0]}")
source $MY_DIR/utils.sh

#
# Function 'do_openssl_build' and 'build_openssl'
# copied from https://github.com/pypa/manylinux/tree/master/docker/build_scripts
#

OPENSSL_ROOT=openssl-1.0.2r
# Hash from https://www.openssl.org/source/openssl-1.0.2r.tar.gz.sha256
OPENSSL_HASH=ae51d08bba8a83958e894946f15303ff894d75c2b8bbd44a852b64e3fe11d0d6

# XXX: the official https server at www.openssl.org cannot be reached
# with the old versions of openssl and curl in Centos 5.11 hence the fallback
# to the ftp mirror:
OPENSSL_DOWNLOAD_URL=ftp://ftp.openssl.org/source

function do_openssl_build {
    ${WRAPPER} ./config no-ssl2 no-shared -fPIC $CONFIG_FLAG --prefix=/usr/local/ssl > /dev/null
    ${WRAPPER} make > /dev/null
    ${WRAPPER} make install_sw > /dev/null
}

function build_openssl {
    local openssl_fname=$1
    check_var ${openssl_fname}
    local openssl_sha256=$2
    check_var ${openssl_sha256}
    check_var ${OPENSSL_DOWNLOAD_URL}
    # Can't use curl here because we don't have it yet
    wget -q ${OPENSSL_DOWNLOAD_URL}/${openssl_fname}.tar.gz
    check_sha256sum ${openssl_fname}.tar.gz ${openssl_sha256}
    tar -xzf ${openssl_fname}.tar.gz
    (cd ${openssl_fname} && do_openssl_build)
    rm -rf ${openssl_fname} ${openssl_fname}.tar.gz
    # Cleanup install tree
    rm -rf /usr/ssl/man
}

cd /usr/src
build_openssl $OPENSSL_ROOT $OPENSSL_HASH
