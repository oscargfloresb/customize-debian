LINGO_URL="https://www.lindo.com/downloads/Lingo-20.0-linux-x64-installer.run"
LINGO_INSTALLER="/tmp/lingo20-installer.run"
LINGO_DIR="/opt/lingo20"

if [[ "$(dpkg --print-architecture)" != "amd64" ]]; then
    echo "ERROR: Lingo 20.0 requiere Debian amd64 (x86_64)." >&2
    exit 1
fi

for cmd in wget rm chmod cat find sed wc; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: no se encuentra el comando requerido: $cmd" >&2
        exit 1
    fi
done

if ! wget -4 \
    --inet4-only \
    --timeout=60 \
    --tries=3 \
    --retry-connrefused \
    -q \
    -O "$LINGO_INSTALLER" \
    "$LINGO_URL"; then

    echo "ERROR: no se pudo descargar Lingo." >&2
    rm -f "$LINGO_INSTALLER"
    exit 1
fi

chmod 755 "$LINGO_INSTALLER"

rm -rf "$LINGO_DIR"

if ! "$LINGO_INSTALLER" \
    --mode unattended \
    --unattendedmodeui none \
    --prefix "$LINGO_DIR" \
    >/dev/null 2>&1; then

    echo "ERROR: la instalación de Lingo falló." >&2
    rm -f "$LINGO_INSTALLER"
    exit 1
fi

if [[ ! -x "$LINGO_DIR/lingo20" ]]; then
    echo "ERROR: no se encontró la GUI de Lingo." >&2
    exit 1
fi

if [[ ! -x "$LINGO_DIR/runlingo" ]]; then
    echo "ERROR: no se encontró RunLingo." >&2
    exit 1
fi

LINGO_ICON="$LINGO_DIR/images/lingo128.ico"

if [[ ! -f "$LINGO_ICON" ]]; then
    echo "ERROR: no se encontró el icono oficial de Lingo." >&2
    exit 1
fi

cat > /etc/profile.d/lingo.sh <<'EOF'
export LINGO_HOME=/opt/lingo20
export PATH="/opt/lingo20:$PATH"
EOF

chmod 644 /etc/profile.d/lingo.sh

cat > /usr/local/bin/lingo <<'EOF'
#!/bin/bash
export LINGO_HOME=/opt/lingo20
exec /opt/lingo20/runlingo "$@"
EOF

chmod 755 /usr/local/bin/lingo

if [[ -f /etc/skel/.bashrc ]]; then
    grep -qxF 'export LINGO_HOME=/opt/lingo20' /etc/skel/.bashrc 2>/dev/null || \
        echo 'export LINGO_HOME=/opt/lingo20' >> /etc/skel/.bashrc

    grep -qxF 'export PATH="/opt/lingo20:$PATH"' /etc/skel/.bashrc 2>/dev/null || \
        echo 'export PATH="/opt/lingo20:$PATH"' >> /etc/skel/.bashrc
fi

if [[ -f /etc/skel/.zshrc ]]; then
    grep -qxF 'export LINGO_HOME=/opt/lingo20' /etc/skel/.zshrc 2>/dev/null || \
        echo 'export LINGO_HOME=/opt/lingo20' >> /etc/skel/.zshrc

    grep -qxF 'export PATH="/opt/lingo20:$PATH"' /etc/skel/.zshrc 2>/dev/null || \
        echo 'export PATH="/opt/lingo20:$PATH"' >> /etc/skel/.zshrc
fi

rm -f "/usr/share/applications/lindo-lingo-20.0.desktop"
rm -f "$LINGO_DIR/Lingo 20.0.desktop"
rm -f "$LINGO_DIR/Uninstall Lingo.desktop"

cat > /usr/share/applications/lingo.desktop <<EOF
[Desktop Entry]
Version=1.0
Name=Lingo
GenericName=Lingo
Comment=Lingo Optimization Modeling Software
Exec=$LINGO_DIR/lingo20
Terminal=false
Type=Application
Icon=$LINGO_ICON
Path=$LINGO_DIR/samples
Categories=Education;Science;Math;
StartupNotify=true
MimeType=application/x-lingo-model;
EOF

chmod 644 /usr/share/applications/lingo.desktop

cat > /usr/share/mime/packages/lingo.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="application/x-lingo-model">
        <comment>Lingo Model</comment>
        <glob pattern="*.lng"/>
        <glob pattern="*.ltf"/>
    </mime-type>
</mime-info>
EOF

if command -v update-mime-database >/dev/null 2>&1; then
    update-mime-database /usr/share/mime >/dev/null 2>&1 || true
fi

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
fi

rm -f "$LINGO_INSTALLER"

export LINGO_HOME="$LINGO_DIR"
export PATH="$LINGO_DIR:$PATH"

ERROR=0

[[ -x "$LINGO_DIR/lingo20" ]] || ERROR=1
[[ -x "$LINGO_DIR/runlingo" ]] || ERROR=1
[[ -x "/usr/local/bin/lingo" ]] || ERROR=1
[[ -f "/usr/share/applications/lingo.desktop" ]] || ERROR=1
[[ ! -e "/usr/share/applications/lindo-lingo-20.0.desktop" ]] || ERROR=1

if [[ "$ERROR" -ne 0 ]]; then
    echo "ERROR: Lingo no quedó instalado correctamente." >&2
    exit 1
fi

LINGO_DESKTOP_COUNT="$(
    find /usr/share/applications \
        -maxdepth 1 \
        -type f \
        \( -iname '*lingo*.desktop' -o -iname '*lindo*lingo*.desktop' \) \
        -print 2>/dev/null |
    sed '/^$/d' |
    wc -l
)"

if [[ "$LINGO_DESKTOP_COUNT" -ne 1 ]]; then
    echo "ERROR: se encontraron $LINGO_DESKTOP_COUNT lanzadores de Lingo." >&2
    exit 1
fi

chown root:oky "$LINGO_DIR/license"
chmod 775 "$LINGO_DIR/license"

chown root:oky "$LINGO_DIR/license/linux64"
chmod 775 "$LINGO_DIR/license/linux64"

echo "Lingo 20.0 instalado correctamente."
