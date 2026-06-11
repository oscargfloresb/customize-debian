#!/bin/bash

apt update && apt upgrade -y && apt install -y \
    linux-headers-$(uname -r) \
    firmware-linux \
    build-essential \
    checkinstall \
    libtool \
    cmake \
    pkg-config \
    flex \
    bison \
    libbz2-dev \
    mesa-utils \
    net-tools \
    gdm3 \
    sudo \
    wget \
    curl \
    git \
    gh \
    c3270 \
    gimp \
    vlc \
    openjdk-21-jdk \
    python3 \
    python3-pip \
    python3-venv \
    python3-tk \
    plymouth-themes \
    gnome-text-editor \
    gnome-console \
    gnome-calculator \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    android-sdk-platform-tools \
    gnome-shell-extension-prefs \
    gnome-shell-extension-dash-to-panel \
    gnome-shell-extension-desktop-icons-ng \
    gnome-shell-extension-tiling-assistant \
    dconf-cli \
    nmap

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

curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && \
  chmod 755 msfinstall && \
  ./msfinstall

curl "https://portswigger.net/burp/releases/download?product=desktop&version=2026.4.3&type=Linux" > burpsuite_linux_v2026_4_3.sh && \
  chmod 755 burpsuite_linux_v2026_4_3.sh && \
  ./burpsuite_linux_v2026_4_3.sh -q

rm -f msfinstall
rm -f burpsuite_linux_v2026_4_3.sh

for url in \
"https://downloads.maltego.com/maltego-v4/linux/Maltego.v4.11.3.deb?_gl=1*faa42*_ga*Nzg4Mzc4MDUyLjE3ODAxOTQ5ODM.*_ga_KLWZNM1QZW*czE3ODAxOTQ5ODMkbzEkZzEkdDE3ODAxOTUyMTEkajEwJGwwJGgw" \
"https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" \
"https://github.com/ONLYOFFICE/DesktopEditors/releases/latest/download/onlyoffice-desktopeditors_amd64.deb" \
"https://cdn.zoom.us/prod/7.0.5.3034/zoom_amd64.deb" \
"https://download.anydesk.com/linux/anydesk_8.0.2-1_amd64.deb" \
"https://download.virtualbox.org/virtualbox/7.2.8/virtualbox-7.2_7.2.8-173730~Debian~trixie_amd64.deb" \
"https://archive.apache.org/dist/netbeans/netbeans-installers/25/apache-netbeans_25-1_all.deb" \
"https://vscode.download.prss.microsoft.com/dbazure/download/stable/8761a5560cfd65fdd19ce7e2bd18dab5c0a4d84e/code_1.122.1-1780040850_amd64.deb" \
"https://raw.githubusercontent.com/oscargfloresb/customize-debian/refs/heads/main/hercules_4.9.1-1_amd64.deb"
do
    file="$(basename "${url%%\?*}")"

    wget -4 --inet4-only --timeout=30 --tries=3 --retry-connrefused \
        -O "${file}" "${url}"

    DEBIAN_FRONTEND=noninteractive dpkg -i "${file}" || \
    DEBIAN_FRONTEND=noninteractive apt install -f -y

    rm -f "${file}"
done

# Install Oh-My-Zsh globally in /etc/skel
if [[ ! -d /etc/skel/.oh-my-zsh ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git /etc/skel/.oh-my-zsh
fi

# Download Debian Shell theme
wget -O /etc/skel/.oh-my-zsh/themes/debian-shell.zsh-theme \
    https://raw.githubusercontent.com/oscargfloresb/customize-debian/refs/heads/main/debian-shell.zsh-theme

# Default .zshrc for new users
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

# Apply Debian Shell to root
if [[ ! -d /root/.oh-my-zsh ]]; then
    cp -r /etc/skel/.oh-my-zsh /root/
fi

cp /etc/skel/.zshrc /root/.zshrc

mkdir -p /root/.oh-my-zsh/themes

cp /etc/skel/.oh-my-zsh/themes/debian-shell.zsh-theme \
   /root/.oh-my-zsh/themes/

chsh -s /usr/bin/zsh root

# Apply Debian Shell to existing users
for home in /home/*; do
    user="$(basename "$home")"

    # Skip invalid directories
    [[ ! -d "$home" ]] && continue

    # Copy Oh-My-Zsh if missing
    if [[ ! -d "$home/.oh-my-zsh" ]]; then
        cp -r /etc/skel/.oh-my-zsh "$home/"
    fi

    # Copy .zshrc
    cp /etc/skel/.zshrc "$home/.zshrc"

    # Ensure theme exists
    mkdir -p "$home/.oh-my-zsh/themes"

    cp /etc/skel/.oh-my-zsh/themes/debian-shell.zsh-theme \
       "$home/.oh-my-zsh/themes/"

    # Set ownership
    chown -R "$user:$user" "$home/.oh-my-zsh"
    chown "$user:$user" "$home/.zshrc"

    # Set default shell
    chsh -s /usr/bin/zsh "$user"
done

###############################################################################
# GNOME Desktop Configuration (Windows 11 Style)
###############################################################################

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

ln -s /usr/lib/x86_64-linux-gnu/libtiff.so.6 /usr/lib/x86_64-linux-gnu/libtiff.so.5
