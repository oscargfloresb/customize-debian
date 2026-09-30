```bash
#!/usr/bin/env bash
set -Eeuo pipefail

PACKAGE="decibels"
VERSION="48.0"
REVISION="1"
ARCH="amd64"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/build-$PACKAGE"
SRC="$WORK/decibels-$VERSION"
STAGE="$WORK/stage"
DIST="$ROOT/dist"

log() {
    printf '\n==> %s\n' "$*"
}

die() {
    echo "ERROR: $*" >&2
    exit 1
}

[[ "$(dpkg --print-architecture)" == "$ARCH" ]] ||
    die "Este script requiere arquitectura $ARCH."

command -v apt-get >/dev/null ||
    die "Se requiere Debian/Ubuntu con apt."

log "Instalando dependencias"

sudo apt-get update

sudo apt-get install -y \
    build-essential \
    meson \
    ninja-build \
    pkg-config \
    gettext \
    xz-utils \
    wget \
    gjs \
    libgtk-4-dev \
    libadwaita-1-dev \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    libglib2.0-dev

rm -rf "$WORK"
mkdir -p "$WORK" "$DIST"

log "Descargando Decibels $VERSION"

cd "$WORK"

wget -O "decibels-$VERSION.tar.xz" \
    "https://download.gnome.org/sources/decibels/48/decibels-$VERSION.tar.xz"

tar -xf "decibels-$VERSION.tar.xz"

cd "$SRC"

log "Configurando Meson"

meson setup build \
    --prefix=/usr \
    --buildtype=release

log "Compilando"

meson compile -C build

log "Instalando en staging"

DESTDIR="$STAGE" meson install -C build

log "Creando metadata Debian"

mkdir -p "$STAGE/DEBIAN"

cat > "$STAGE/DEBIAN/control" <<EOF
Package: $PACKAGE
Version: $VERSION-$REVISION
Section: sound
Priority: optional
Architecture: $ARCH
Maintainer: Local Build <local@localhost>
Depends: gjs, gir1.2-gtk-4.0, gir1.2-adw-1, gir1.2-gstreamer-1.0, gir1.2-gst-plugins-base-1.0
Description: Simple audio player for GNOME
 Decibels is a simple audio player for GNOME.
EOF

cat > "$STAGE/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database -q /usr/share/applications || true
fi

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -q -f -t /usr/share/icons/hicolor || true
fi

exit 0
EOF

chmod 0755 "$STAGE/DEBIAN/postinst"

log "Construyendo paquete"

rm -f "$DIST/${PACKAGE}_${VERSION}-${REVISION}_${ARCH}.deb"

dpkg-deb \
    --root-owner-group \
    --build \
    "$STAGE" \
    "$DIST/${PACKAGE}_${VERSION}-${REVISION}_${ARCH}.deb"

log "Paquete generado"

dpkg-deb --info \
    "$DIST/${PACKAGE}_${VERSION}-${REVISION}_${ARCH}.deb"

echo
echo "OK:"
echo "$DIST/${PACKAGE}_${VERSION}-${REVISION}_${ARCH}.deb"
```

