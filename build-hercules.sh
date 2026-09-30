```bash
#!/usr/bin/env bash
set -Eeuo pipefail

PACKAGE="hercules"
VERSION="4.9.1"
PACKAGE_VERSION="4.9.1-1"
ARCH="amd64"

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK="$ROOT/build-$PACKAGE"
DIST="$ROOT/dist"
SRC="$WORK/hyperion"

log() {
    printf '\n==> %s\n' "$*"
}

die() {
    echo "ERROR: $*" >&2
    exit 1
}

[[ "$(dpkg --print-architecture)" == "$ARCH" ]] ||
    die "Este script requiere arquitectura $ARCH."

log "Instalando dependencias"

sudo apt-get update

sudo apt-get install -y \
    build-essential \
    git \
    autoconf \
    automake \
    libtool \
    flex \
    bison \
    gawk \
    gettext \
    libbz2-dev \
    zlib1g-dev \
    libssl-dev \
    libncurses-dev \
    checkinstall

rm -rf "$WORK"
mkdir -p "$WORK" "$DIST"

log "Clonando Hercules Hyperion $VERSION"

git clone \
    --depth=1 \
    --branch "Release_$VERSION" \
    https://github.com/SDL-Hercules-390/hyperion.git \
    "$SRC"

cd "$SRC"

log "Generando configure"

./autogen.sh

log "Configurando"

./configure \
    --prefix=/usr \
    --sysconfdir=/etc

log "Compilando"

make -j"$(nproc)"

log "Creando paquete mediante checkinstall"

# checkinstall ejecuta "make install" dentro de su
# sistema de empaquetado y crea el .deb sin instalarlo
# permanentemente en el sistema.
#
# --fstrans=no es importante para este método porque
# Hercules instala bibliotecas, módulos y utilidades
# en varios directorios.

checkinstall \
    --install=no \
    --fstrans=no \
    --backup=no \
    --pakdir="$DIST" \
    --type=debian \
    --pkgname="$PACKAGE" \
    --pkgversion="$PACKAGE_VERSION" \
    --pkgrelease="" \
    --maintainer="oscargfloresb@outlook.com" \
    --nodoc \
    --requires="libc6,libbz2-1.0,zlib1g,libssl3" \
    make install

log "Buscando paquete"

DEB="$DIST/${PACKAGE}_${PACKAGE_VERSION}_${ARCH}.deb"

if [[ ! -f "$DEB" ]]; then
    # Algunas versiones de checkinstall pueden generar
    # un nombre ligeramente diferente. Buscarlo.
    FOUND="$(find "$DIST" -maxdepth 1 -type f -name "${PACKAGE}_*.deb" -print -quit)"

    [[ -n "$FOUND" ]] ||
        die "checkinstall no produjo ningún .deb"

    DEB="$FOUND"
fi

log "Paquete generado"

dpkg-deb --info "$DEB"

echo
echo "OK:"
echo "$DEB"
```

