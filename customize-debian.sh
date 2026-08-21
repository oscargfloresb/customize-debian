#!/bin/bash

apt update && apt upgrade -y && apt install -y \
linux-headers-$(uname -r) \
firmware-linux \
sudo \
mesa-utils \
net-tools \
libsecret-tools \
dconf-cli \
openjdk-21-jdk \
python3 \
python3-pip \
python3-venv \
python3-tk \
gir1.2-gsound-1.0 \
gstreamer1.0-opencv \
build-essential \
android-sdk-platform-tools \
zsh \
zsh-syntax-highlighting \
zsh-autosuggestions \
wget \
curl \
git \
gh \
gdm3 \
gnome-text-editor \
gnome-console \
gnome-calculator \
gimp \
papers \
loupe \
showtime \
snapshot

pip3 install librosa --break-system-packages

cd /tmp

wget -qO- https://dl.google.com/linux/linux_signing_key.pub \
| gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] \
https://dl.google.com/linux/chrome/deb/ stable main" \
> /etc/apt/sources.list.d/google-chrome.list

wget -qO- https://packages.microsoft.com/keys/microsoft.asc \
| gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] \
https://packages.microsoft.com/repos/code stable main" \
> /etc/apt/sources.list.d/vscode.list

wget -qO- https://www.virtualbox.org/download/oracle_vbox_2016.asc \
| gpg --dearmor -o /etc/apt/keyrings/virtualbox.gpg

echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/virtualbox.gpg] \
https://download.virtualbox.org/virtualbox/debian trixie contrib" \
> /etc/apt/sources.list.d/virtualbox.list

wget -qO- https://keys.anydesk.com/repos/DEB-GPG-KEY \
| gpg --dearmor -o /etc/apt/keyrings/anydesk.gpg

echo "deb [signed-by=/etc/apt/keyrings/anydesk.gpg] \
http://deb.anydesk.com/ all main" \
> /etc/apt/sources.list.d/anydesk.list

wget -qO- https://download.onlyoffice.com/GPG-KEY-ONLYOFFICE \
| gpg --dearmor -o /etc/apt/keyrings/onlyoffice.gpg

echo "deb [signed-by=/etc/apt/keyrings/onlyoffice.gpg] \
https://download.onlyoffice.com/repo/debian squeeze main" \
> /etc/apt/sources.list.d/onlyoffice.list

apt update && apt install -y \
google-chrome-stable \
onlyoffice-desktopeditors \
code \
virtualbox-7.2 \
anydesk

urls=(
    "https://zoom.us/client/latest/zoom_amd64.deb"
    "https://archive.apache.org/dist/netbeans/netbeans-installers/25/apache-netbeans_25-1_all.deb"
    "https://dca.ufrn.br/~viegas/disciplinas/DCA3605/files/Simulador/822/CiscoPacketTracer822_amd64_signed.deb"
    "https://raw.githubusercontent.com/oscargfloresb/customize-debian/refs/heads/main/pitivi_2023.03-2%2Bgtksink_amd64.deb"
    "https://raw.githubusercontent.com/oscargfloresb/customize-debian/refs/heads/main/hercules_4.9.1-1_amd64.deb"
)

for url in "${urls[@]}"; do
    file="$(basename "${url%%\?*}")"

    if [[ "${file}" == "CiscoPacketTracer822_amd64_signed.deb" ]]; then

        if ! wget -4 --inet4-only --no-check-certificate \
            --timeout=30 --tries=3 --retry-connrefused \
            -O "${file}" "${url}"; then
            echo "ERROR: no se pudo descargar Packet Tracer desde ${url}." >&2
            exit 1
        fi

        mkdir -p /root/.config

        apt install -y \
            dialog \
            libxcb-xinerama0-dev \
            libgl1 \
            libglx-mesa0 \
            libopengl0 \
            libxcb-xinerama0

        echo "PacketTracer_822_amd64 PacketTracer_822_amd64/accept-eula boolean true" \
            | debconf-set-selections

        rm -rf /tmp/packettracer-extract
        dpkg-deb -R "${file}" /tmp/packettracer-extract

        pt_pkgname="$(dpkg-deb -f "${file}" Package)"

        sed -i 's/libgl1-mesa-glx/libgl1/g' \
            /tmp/packettracer-extract/DEBIAN/control

        rm -f /tmp/packettracer-fixed.deb
        dpkg-deb -b /tmp/packettracer-extract /tmp/packettracer-fixed.deb

        DEBIAN_FRONTEND=noninteractive \
        apt-get install -y /tmp/packettracer-fixed.deb \
            || { echo "ERROR: apt-get install de Packet Tracer falló." >&2; \
                 rm -rf /tmp/packettracer-extract /tmp/packettracer-fixed.deb; \
                 exit 1; }

        rm -rf /tmp/packettracer-extract /tmp/packettracer-fixed.deb

        if dpkg-query -W -f='${Status}' "${pt_pkgname}" 2>/dev/null \
            | grep -q "install ok installed"; then
            apt-mark hold "${pt_pkgname}"
        else
            echo "ERROR: Packet Tracer no quedó instalado correctamente." >&2
            echo "Dependencias declaradas por el .deb:" >&2
            dpkg-deb -f "${file}" Depends >&2
            exit 1
        fi

    else

        wget -4 --inet4-only \
            --timeout=30 --tries=3 --retry-connrefused \
            -O "${file}" "${url}" || continue

        DEBIAN_FRONTEND=noninteractive dpkg -i "${file}" || \
        DEBIAN_FRONTEND=noninteractive apt install -f -y

    fi

    rm -f "${file}"
done

github_install_latest_deb() {

    local owner repo match
    local arch url file

    arch="$(dpkg --print-architecture)"

    while (( $# >= 3 )); do

        owner="$1"
        repo="$2"
        match="$3"

        shift 3

        echo "Descargando ${owner}/${repo}..."

        url=$(
            curl -fsSL "https://api.github.com/repos/${owner}/${repo}/releases/latest" |
            jq -r \
                --arg arch "$arch" \
                --arg match "$match" '
                .assets[]
                | select(
                    (.name | endswith(".deb")) and
                    (.name | contains($match)) and
                    (
                        (.name | contains("_" + $arch + ".deb")) or
                        (.name | contains("-" + $arch + ".deb")) or
                        (.name | contains("_all.deb"))
                    )
                )
                | .browser_download_url
                ' | head -n1
        )

        if [[ -z "$url" ]]; then
            echo "No se encontró un paquete para ${owner}/${repo}"
            continue
        fi

        file="/tmp/$(basename "$url")"

        wget -q --show-progress -O "$file" "$url"

        DEBIAN_FRONTEND=noninteractive dpkg -i "$file" || \
        DEBIAN_FRONTEND=noninteractive apt install -fy

        rm -f "$file"

    done
}

github_install_latest_deb \
    raspberrypi rpi-imager rpi-imager_ \
    obsidianmd obsidian-releases obsidian

if [[ ! -d /etc/skel/.oh-my-zsh ]]; then
git clone https://github.com/ohmyzsh/ohmyzsh.git /etc/skel/.oh-my-zsh
fi

wget -O /etc/skel/.oh-my-zsh/themes/debian-shell.zsh-theme \
https://raw.githubusercontent.com/oscargfloresb/customize-debian/refs/heads/main/debian-shell.zsh-theme

cat > /etc/skel/.zshrc <<'EOF'
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="debian-shell"

plugins=(
git
)

source $ZSH/oh-my-zsh.sh

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF

if [[ ! -d /root/.oh-my-zsh ]]; then
cp -r /etc/skel/.oh-my-zsh /root/
fi

cp /etc/skel/.zshrc /root/.zshrc

mkdir -p /root/.oh-my-zsh/themes

cp /etc/skel/.oh-my-zsh/themes/debian-shell.zsh-theme \
/root/.oh-my-zsh/themes/

chsh -s /usr/bin/zsh root

for home in /home/*; do
user="$(basename "$home")"

[[ ! -d "$home" ]] && continue

if [[ ! -d "$home/.oh-my-zsh" ]]; then
cp -r /etc/skel/.oh-my-zsh "$home/"
fi

cp /etc/skel/.zshrc "$home/.zshrc"

mkdir -p "$home/.oh-my-zsh/themes"

cp /etc/skel/.oh-my-zsh/themes/debian-shell.zsh-theme \
"$home/.oh-my-zsh/themes/"

chown -R "$user:$user" "$home/.oh-my-zsh"
chown "$user:$user" "$home/.zshrc"

chsh -s /usr/bin/zsh "$user"
done

mkdir -p /usr/share/images/custom
mkdir -p /usr/share/gnome-shell/extensions
mkdir -p /etc/dconf/profile
mkdir -p /etc/dconf/db/local.d

wget -q -O /usr/share/images/custom/desktop-grub.png \
https://raw.githubusercontent.com/oscargfloresb/customize-debian/main/desktop-grub.png

wget -q -O /usr/share/images/custom/desktop-background \
https://raw.githubusercontent.com/oscargfloresb/customize-debian/main/desktop-background

wget -q -O /tmp/tilingshell@ferrarodomenico.com.zip \
https://github.com/domferr/tilingshell/releases/latest/download/tilingshell@ferrarodomenico.com.zip

unzip -oq /tmp/tilingshell@ferrarodomenico.com.zip \
-d /usr/share/gnome-shell/extensions/tilingshell@ferrarodomenico.com

rm -f /tmp/tilingshell@ferrarodomenico.com.zip

cat > /etc/dconf/profile/user <<'EOF'
user-db:user
system-db:local
EOF

cat > /etc/dconf/db/local.d/00-gnome-desktop <<'EOF'
[org/gnome/shell]
enabled-extensions=['tilingshell@ferrarodomenico.com']

[org/gnome/desktop/background]
picture-uri='file:///usr/share/images/custom/desktop-background'
picture-uri-dark='file:///usr/share/images/custom/desktop-background'
picture-options='zoom'

[org/gnome/desktop/screensaver]
picture-uri='file:///usr/share/images/custom/desktop-background'
lock-enabled=true
lock-delay=uint32 0

[org/gnome/desktop/session]
idle-delay=uint32 300

[org/gnome/settings-daemon/plugins/power]
sleep-inactive-ac-type='nothing'
sleep-inactive-battery-type='nothing'
power-button-action='interactive'

[org/gnome/desktop/wm/preferences]
button-layout=':minimize,maximize,close'

[org/gnome/Console]
theme='auto'
EOF

dconf update

archive=".backup-$(date +'%Y%m%d%H%M%S')"

sed -i"${archive}" 's|^WALLPAPER=.*|WALLPAPER=/usr/share/images/custom/desktop-grub.png|' /usr/share/desktop-base/ceratopsian-theme/grub/grub_background.sh

sed -i"${archive}" 's/managed=false/managed=true/g' /etc/NetworkManager/NetworkManager.conf

sed -i"${archive}" '13d;14d' /etc/network/interfaces

update-grub

cat > /etc/udisks2/mount_options.conf <<'EOF'
[defaults]
ntfs_drivers=ntfs
EOF

usermod -aG sudo oky
usermod -aG vboxusers oky
usermod -aG dialout oky

pt_check="${pt_pkgname:-packettracer}"

if dpkg-query -W -f='${Status}' "${pt_check}" 2>/dev/null \
    | grep -q "install ok installed"; then

    if apt-mark showhold | grep -qx "${pt_check}"; then
        echo "OK: Packet Tracer está instalado y protegido con hold."
    else
        echo "ERROR: Packet Tracer está instalado pero ya NO está en hold." >&2
        echo "Alguna operación de apt pudo haber tocado el paquete; revisa" >&2
        echo "/var/log/apt/history.log y vuelve a fijarlo con:" >&2
        echo "  apt-mark hold ${pt_check}" >&2
        exit 1
    fi

else
    echo "ERROR: Packet Tracer NO está instalado al finalizar el script." >&2
    echo "Revisa /var/log/apt/history.log para ver en qué paso se eliminó." >&2
    exit 1
fi
