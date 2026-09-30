```bash
#!/usr/bin/env bash
set -Eeuo pipefail

PACKAGE="pw3270"
VERSION="5.5.0"
ARCH="amd64"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/build-$PACKAGE"
SRC="$WORK/pw3270"
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

command -v git >/dev/null ||
    die "git no está instalado."

log "Instalando dependencias"

sudo apt-get update

sudo apt-get install -y \
    build-essential \
    git \
    meson \
    ninja-build \
    pkg-config \
    gettext \
    libgtk-3-dev \
    libglib2.0-dev \
    libgdk-pixbuf-2.0-dev \
    libpango1.0-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    scour \
    optipng

rm -rf "$WORK"
mkdir -p "$WORK" "$DIST"

log "Clonando pw3270"

git clone \
    --depth=1 \
    --branch "$VERSION" \
    https://github.com/PerryWerneck/pw3270.git \
    "$SRC"

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
Version: $VERSION
Section: net
Priority: optional
Architecture: $ARCH
Maintainer: Local Build <local@localhost>
Depends: libc6, libgtk-3-0, libglib2.0-0, libgdk-pixbuf-2.0-0, libpango-1.0-0, libcairo2, libcurl4, libssl3
Description: GTK based 3270 terminal emulator
 pw3270 is a modern GTK based tn3270 terminal emulator.
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

rm -f "$DIST/${PACKAGE}_${VERSION}_${ARCH}.deb"

dpkg-deb \
    --root-owner-group \
    --build \
    "$STAGE" \
    "$DIST/${PACKAGE}_${VERSION}_${ARCH}.deb"

log "Paquete generado"

dpkg-deb --info \
    "$DIST/${PACKAGE}_${VERSION}_${ARCH}.deb"

echo
echo "OK:"
echo "$DIST/${PACKAGE}_${VERSION}_${ARCH}.deb"
```

