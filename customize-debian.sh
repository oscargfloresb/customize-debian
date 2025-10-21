#!/bin/bash

apt update && apt upgrade -y

apt install -y \
linux-headers-$(uname -r) \
firmware-linux \
build-essential \
gdm3 \
ssh \
sudo \
openjdk-21-jdk \
python3-venv \
python3-pip \
python3-tk \
git \
curl \
wget \
nautilus \
baobab \
evince \
eog \
gnome-terminal \
gnome-calendar \
gnome-calculator \
gnome-software \
gnome-system-monitor \
gnome-disk-utility \
gnome-logs \
gnome-characters \
gnome-font-viewer \
zsh \

usermod -aG sudo oky

archive=".backup.$(date +'%Y%m%d%H%M%S')"

sed -i"${archive}" 's/managed=false/managed=true/g' /etc/NetworkManager/NetworkManager.conf

sed -i"${archive}" '13d;14d' /etc/network/interfaces

sed -i"${archive}" 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen

locale-gen

sed -i"${archive}" 's/LANG="C"/LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8/' /etc/default/locale

update-locale

sed -i"${archive}" 's/#WaylandEnable=false/WaylandEnable=false/g' /etc/gdm3/daemon.conf

sed -i"${archive}" 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub

update-grub2

THEME_URL="https://raw.githubusercontent.com/oscargfloresb/customize-debian/master/debian.zsh-theme"
THEME_TEMP="/tmp/debian.zsh-theme"
OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
ZSHRC_MARKER="# === ZSH DEBIAN THEME INSTALLED ==="

echo "Descargando tema Debian en $THEME_TEMP..."

wget -4 -O "$THEME_TEMP" "$THEME_URL"

configure_user() {
local USERNAME="$1"
local USER_HOME="$2"

echo "Verificando configuración para usuario: $USERNAME"

if [ -f "$USER_HOME/.zshrc" ] && grep -q "$ZSHRC_MARKER" "$USER_HOME/.zshrc"; then
echo "Ya configurado, omitiendo."
return
fi

echo "Configurando Zsh y tema Debian para $USERNAME"

if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
sudo -u "$USERNAME" sh -c \
"$(curl -fsSL $OH_MY_ZSH_INSTALL_URL)" "" --unattended
fi

sudo -u "$USERNAME" mkdir -p "$USER_HOME/.oh-my-zsh/custom/themes"

cp "$THEME_TEMP" "$USER_HOME/.oh-my-zsh/custom/themes/debian.zsh-theme"

chown "$USERNAME:$USERNAME" "$USER_HOME/.oh-my-zsh/custom/themes/debian.zsh-theme"

cat <<EOF > "$USER_HOME/.zshrc"
$ZSHRC_MARKER
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="debian"
plugins=(git)
source \$ZSH/oh-my-zsh.sh
EOF
chown "$USERNAME:$USERNAME" "$USER_HOME/.zshrc"

chsh -s "$(which zsh)" "$USERNAME"
}

for dir in /home/*; do
[ -d "$dir" ] || continue
USERNAME=$(basename "$dir")
configure_user "$USERNAME" "$dir"
done

configure_user root /root

if [ -f /etc/skel/.zshrc ] && grep -q "$ZSHRC_MARKER" /etc/skel/.zshrc; then
echo "[/etc/skel ya está configurado para Zsh con Debian."
else
echo "Configurando /etc/skel para nuevos usuarios..."

TMP_SKEL="/tmp/skeluser"

useradd -m -d "$TMP_SKEL" -s "$(which zsh)" skeluser

sudo -u skeluser sh -c \
"$(curl -fsSL $OH_MY_ZSH_INSTALL_URL)" "" --unattended

mkdir -p "$TMP_SKEL/.oh-my-zsh/custom/themes"

cp "$THEME_TEMP" "$TMP_SKEL/.oh-my-zsh/custom/themes/debian.zsh-theme"

cat <<EOF > "$TMP_SKEL/.zshrc"
$ZSHRC_MARKER
export ZSH="\$HOME/.oh-my-zsh"
ZSH_THEME="debian"
plugins=(git)
source \$ZSH/oh-my-zsh.sh
EOF

rm -rf /etc/skel/.oh-my-zsh /etc/skel/.zshrc 2>/dev/null || true

cp -r "$TMP_SKEL/.oh-my-zsh" /etc/skel/

cp "$TMP_SKEL/.zshrc" /etc/skel/

chown -R root:root /etc/skel/.oh-my-zsh /etc/skel/.zshrc

userdel -r skeluser 2>/dev/null || true
fi

echo "Todos los usuarios actuales y futuros usarán Zsh con tema Debian."
