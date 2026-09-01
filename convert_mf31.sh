#!/bin/bash

cd /home/oky/Mainframe || exit 1

# Copia de seguridad
cp MF_31.cnf MF_31.cnf.bak

# Configurar CNSLPORT 3270
sed -i -E 's/^[[:space:]]*CNSLPORT[[:space:]]+992/#CNSLPORT 992/; s/^[[:space:]]*#CNSLPORT[[:space:]]+3270/CNSLPORT 3270/' MF_31.cnf

# Convertir rutas Windows a Linux
sed -i 's#C:\\Users\\Public\\ZOS111\\LOGS\\logzOS#/home/oky/Mainframe/LOGS/mainframe.log#g' MF_31.cnf
sed -i 's#C:\\hercules\\sdl-hyperion\\msvc\.AMD64\.bin#/usr/lib/hercules#g' MF_31.cnf
sed -i 's#D:\\zos31\\#/home/oky/Mainframe/#g' MF_31.cnf
sed -i 's#C:\\Users\\Public\\ZOS111\\Confile\\IPL31\.rc#/home/oky/Mainframe/IPL31.rc#g' MF_31.cnf

# Eliminar finales CRLF de Windows
sed -i 's/\r$//' MF_31.cnf

# Configuración QETH para Linux TUN/TAP
sed -i -E \
's#^1500\.3 QETH iface [^[:space:]]+#1500.3 QETH iface /dev/net/tun#' \
MF_31.cnf

# Archivo temporal
tmp="MF_31.tmp"
> "$tmp"

# Procesar configuración
while IFS= read -r linea || [ -n "$linea" ]; do

    if [[ "$linea" =~ ^DE[0-9A-F]+[[:space:]]+3390[[:space:]]+(/home/oky/Mainframe/[^[:space:]]+\.CCKD)[[:space:]]+cu=3990-6[[:space:]]*$ ]]; then

        dispositivo="${linea%% *}"

        resto="${linea#"$dispositivo"}"
        resto="${resto#*3390}"
        resto="${resto#"${resto%%[![:space:]]*}"}"

        imagen="${resto%% *}"

        nombre="${imagen##*/}"
        nombre="${nombre%.CCKD}"

        linea="$dispositivo 3390   $imagen sf=/home/oky/Mainframe/SHADOW/${nombre}_*.CCKD cu=3990-6"
    fi

    printf '%s\n' "$linea" >> "$tmp"

done < MF_31.cnf

mv "$tmp" MF_31.cnf

echo
echo "=========================================="
echo " Configuración MF_31.cnf actualizada"
echo "=========================================="
echo

echo "DASD con shadow:"
grep 'sf=/home/oky/Mainframe/SHADOW/' MF_31.cnf

echo
echo "Cantidad de SF:"
grep -c 'sf=/home/oky/Mainframe/SHADOW/' MF_31.cnf
