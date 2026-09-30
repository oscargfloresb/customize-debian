```bash
#!/usr/bin/env bash
set -Eeuo pipefail

PACKAGE="pitivi"
UPSTREAM_VERSION="2023.03"
DEBIAN_VERSION="2"
PACKAGE_VERSION="2023.03-2+gtksink"
ARCH="amd64"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/build-$PACKAGE"
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

sudo apt-get update

log "Instalando herramientas de construcción"

sudo apt-get install -y \
    build-essential \
    devscripts \
    debhelper \
    dh-python \
    python3-all \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    meson \
    ninja-build \
    pkg-config \
    gettext \
    git \
    wget \
    xz-utils

rm -rf "$WORK"
mkdir -p "$WORK" "$DIST"

cd "$WORK"

log "Descargando fuente Debian de PiTiVi $UPSTREAM_VERSION-$DEBIAN_VERSION"

ORIG="pitivi_${UPSTREAM_VERSION}.orig.tar.xz"
DEBIAN="pitivi_${UPSTREAM_VERSION}-${DEBIAN_VERSION}.debian.tar.xz"
DSC="pitivi_${UPSTREAM_VERSION}-${DEBIAN_VERSION}.dsc"

wget -O "$ORIG" \
    "https://deb.debian.org/debian/pool/main/p/pitivi/$ORIG"

wget -O "$DEBIAN" \
    "https://deb.debian.org/debian/pool/main/p/pitivi/$DEBIAN"

wget -O "$DSC" \
    "https://deb.debian.org/debian/pool/main/p/pitivi/$DSC"

log "Extrayendo fuente Debian"

dpkg-source -x "$DSC"

SRC="$WORK/pitivi-$UPSTREAM_VERSION"

cd "$SRC"

log "Aplicando parche gtksink"

PATCH="$WORK/viewer-Fix-a-race-where-gtksink-is-started-before-being-embedded.patch"

wget -O "$PATCH" \
    "https://sources.debian.org/data/main/p/pitivi/2023.03-6/debian/patches/viewer-Fix-a-race-where-gtksink-is-started-before-being-e.patch"

patch -p1 < "$PATCH"

log "Actualizando versión Debian"

# Evita depender de una versión concreta de sed para modificar
# la primera entrada del changelog.
DEBEMAIL="${DEBEMAIL:-local@localhost}" \
DEBFULLNAME="${DEBFULLNAME:-Local Build}" \
dch --newversion "$PACKAGE_VERSION" \
    --distribution UNRELEASED \
    "Apply upstream gtksink race fix (52cb30ae)."

log "Construyendo PiTiVi"

dpkg-buildpackage \
    -us \
    -uc \
    -b

log "Buscando paquete generado"

DEB="$WORK/${PACKAGE}_${PACKAGE_VERSION}_${ARCH}.deb"

[[ -f "$DEB" ]] ||
    die "No se encontró $DEB"

cp -f "$DEB" "$DIST/"

log "Paquete generado"

dpkg-deb --info "$DIST/$(basename "$DEB")"

echo
echo "OK:"
echo "$DIST/$(basename "$DEB")"
```

