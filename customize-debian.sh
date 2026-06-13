#!/bin/bash

apt update && apt upgrade -y && apt install -y \
    linux-headers-$(uname -r) \
    firmware-linux \
    sudo \
    plymouth-themes \
    mesa-utils \
    net-tools \
    libsecret-tools \
    dconf-cli \
    openjdk-21-jdk \
    python3 \
    python3-pip \
    python3-venv \
    python3-tk \
    build-essential \
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
    gnome-shell-extension-prefs \
    gnome-shell-extension-dash-to-panel \
    gnome-shell-extension-desktop-icons-ng \
    gnome-shell-extension-tiling-assistant \
    gimp \
    papers \
    loupe \
    showtime

archive=".backup-$(date +'%Y%m%d%H%M%S')"

sed -i"${archive}" 's/managed=false/managed=true/g' /etc/NetworkManager/NetworkManager.conf

sed -i"${archive}" '13d;14d' /etc/network/interfaces

sed -i"${archive}" 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/' /etc/default/grub

sed -i"${archive}" 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=0 systemd.show_status=false"/' /etc/default/grub

sed -i"${archive}" 's/quiet_boot="0"/quiet_boot="1"/' /etc/grub.d/10_linux

echo 'GRUB_TERMINAL_OUTPUT=console' >> /etc/default/grub

echo 'GRUB_TIMEOUT_STYLE=hidden' >> /etc/default/grub

plymouth-set-default-theme -R bgrt

update-grub

cat > /etc/udisks2/mount_options.conf <<'EOF'
[defaults]
ntfs_drivers=ntfs
EOF

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
)

for url in "${urls[@]}"; do
    file="$(basename "${url%%\?*}")"

    wget -4 --inet4-only --timeout=30 --tries=3 --retry-connrefused \
        -O "${file}" "${url}" || continue

    DEBIAN_FRONTEND=noninteractive dpkg -i "${file}" || \
        DEBIAN_FRONTEND=noninteractive apt install -f -y

    rm -f "${file}"
done

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

mkdir -p /usr/share/backgrounds/custom

wget -O /usr/share/backgrounds/custom/wallpaper.jpg \
https://raw.githubusercontent.com/oscargfloresb/customize-debian/main/wallpaper.jpg

mkdir -p /etc/dconf/profile
mkdir -p /etc/dconf/db/local.d
mkdir -p /etc/dconf/db/local.d/locks

cat > /etc/dconf/profile/user <<'EOF'
user-db:user
system-db:local
EOF

cat > /etc/dconf/db/local.d/00-gnome-desktop <<'EOF'
[org/gnome/shell]
enabled-extensions=['ding@rastersoft.com','dash-to-panel@jderose9.github.com','tiling-assistant@leleat-on-github']

[org/gnome/shell/extensions/ding]
show-home=true
show-trash=true
show-volumes=true
show-network-volumes=true

[org/gnome/shell/extensions/dash-to-panel]
group-apps=true
panel-positions='{"0":"BOTTOM"}'
panel-sizes='{"0":44}'
show-appmenu=false
show-showdesktop-button=true
multi-monitors=false

[org/gnome/desktop/interface]
clock-format='24h'
clock-show-date=true
clock-show-weekday=false
clock-show-seconds=false

[org/gnome/Console]
theme='auto'

[org/gnome/desktop/background]
picture-uri='file:///usr/share/backgrounds/custom/wallpaper.jpg'
picture-uri-dark='file:///usr/share/backgrounds/custom/wallpaper.jpg'
picture-options='zoom'
primary-color='#000000'
secondary-color='#000000'

[org/gnome/desktop/session]
idle-delay=uint32 300

[org/gnome/desktop/screensaver]
lock-enabled=true
lock-delay=uint32 0

[org/gnome/settings-daemon/plugins/power]
sleep-inactive-ac-type='nothing'
sleep-inactive-battery-type='nothing'
power-button-action='interactive'

[org/gnome/desktop/wm/preferences]
button-layout=':minimize,maximize,close'
EOF

cat > /etc/dconf/db/local.d/locks/dash-to-panel <<'EOF'
/org/gnome/shell/extensions/dash-to-panel/multi-monitors
EOF

dconf update

usermod -aG sudo oky
usermod -aG vboxusers oky
usermod -aG dialout oky

# Fin de la personalizacion del sistema.
