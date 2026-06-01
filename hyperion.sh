#!/usr/bin/env bash

set -euo pipefail

PKG_NAME="hercules"
PKG_VERSION="4.9.1"
PKG_RELEASE="1"
BUILD_DIR="/tmp/hyperion"

echo "[*] Installing build dependencies..."

apt update

DEBIAN_FRONTEND=noninteractive apt install -y \
    git \
    build-essential \
    checkinstall \
    autoconf \
    automake \
    libtool \
    m4 \
    wget

echo "[*] Cleaning old build directory..."

rm -rf "${BUILD_DIR}"

echo "[*] Cloning source..."

git clone https://github.com/SDL-Hercules-390/hyperion.git "${BUILD_DIR}"

cd "${BUILD_DIR}"

echo "[*] Configuring build..."

./configure \
    --prefix=/usr \
    --sysconfdir=/etc

echo "[*] Compiling..."

make -j"$(nproc)"

echo "[*] Building Debian package..."

checkinstall -y \
    --install=no \
    --pkgname="${PKG_NAME}" \
    --pkgversion="${PKG_VERSION}" \
    --pkgrelease="${PKG_RELEASE}" \
    --pkglicense="Q Public License" \
    --pkgsource="https://github.com/SDL-Hercules-390/hyperion" \
    --maintainer="oscargfloresb@outlook.com" \
    --pakdir="/tmp" \
    --backup=no \
    --deldoc=yes \
    --fstrans=no \
    --default

echo
echo "[+] Package created successfully:"
echo
ls -lh /tmp/*.deb