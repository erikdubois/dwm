#!/bin/bash
#set -e
#tput setaf 0 = black
#tput setaf 1 = red
#tput setaf 2 = green
#tput setaf 3 = yellow
#tput setaf 4 = dark blue
#tput setaf 5 = purple
#tput setaf 6 = cyan
#tput setaf 7 = gray
#tput setaf 8 = light blue

echo
tput setaf 2
echo "################################################################"
echo "BUILDING DWM"
echo "################################################################"
tput sgr0
echo

# install packages
sudo pacman -S --noconfirm --needed sxhkd
sudo pacman -S --noconfirm --needed go
sudo pacman -S --noconfirm --needed rofi-lbonn-wayland
sudo pacman -S --noconfirm --needed numlockx
sudo pacman -S --noconfirm --needed feh
sudo pacman -S --noconfirm --needed xorg-xrandr
sudo pacman -S --noconfirm --needed arandr

# File management
if [ -d dwm ]; then
	sudo rm -r dwm
fi
if [ -d sysmon ] ; then
	sudo rm -r sysmon
fi

sudo cp -vf dwm.desktop /usr/share/xsessions/dwm.desktop
if [ ! -d ~/.config/dwm ]; then
	mkdir ~/.config/dwm
fi
cp -v autostart.sh ~/.config/dwm
cp -v sxhkdrc ~/.config/dwm
git clone https://git.suckless.org/dwm
cp -v rebuild.sh dwm

# changed official patches
mkdir dwm/patched-patches
cp -v patched-patches/* dwm/patched-patches

# offical patches
mkdir dwm/patches
cp -v get-patches.sh dwm/patches
cd dwm/patches
sh get-patches.sh
cd ..

## testing patch
#patch < patches/dwm-systray-20230922-9f88553.diff
#sh rebuild.sh
#exit 1

# patching
echo
tput setaf 2
echo "################################################################"
echo "Patch 1"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-cfacts-vanitygaps-6.4_combo.diff
echo
tput setaf 2
echo "################################################################"
echo "Patch 2"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-alpha-20230401-348f655.diff
echo
tput setaf 2
echo "################################################################"
echo "Patch 3"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-autostart-20210120-cb3f58a.diff
echo
tput setaf 2
echo "################################################################"
echo "Patch 4"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-bartoggle-6.4.diff
echo
tput setaf 2
echo "################################################################"
echo "Patch 5"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-alwayscenter-20200625-f04cac6.diff
tput setaf 2
echo "################################################################"
echo "Patch 6"
echo "################################################################"
tput sgr0
echo
patch < patches/dwm-dragmfact-6.2.diff

# personal patching as official did not work
tput setaf 2
echo "################################################################"
echo "Patch 7"
echo "################################################################"
tput sgr0
echo
patch < patched-patches/dwm-cyclelayouts-2024-07-06.diff

#patch < patched-patches/dwm-r1615-2024-07-06.diff
# exit 1
# echo "HERE"
# patch < patches/dwm-r1615-selfrestart.diff

# patch < patches/dwm-winicon-6.3-v2.1.diff

# exit 1
# patch < patches/dwm-movestack-20211115-a786211.diff

# patch < patches/dwm-r1615-selfrestart.diff
# exit 1
# patch < patches/dwm-underlinetags-6.2.diff
# patch < patches/dwm-shif-tools-6.2.diff

# personal config
cp -v config.def.h ../config.def.h
cd ..
diff -U 3 config.def.h config.def.custom.h > to-be-changed.diff
cp -v to-be-changed.diff dwm
cd dwm
patch < to-be-changed.diff

echo "Change directory for autostart"
sed -i 's|static const char localshare\[] = ".local/share";|static const char localshare\[] = ".config";|' dwm.c

sh rebuild.sh
cd ..
# https://github.com/blmayer/sysmon
echo "Adding sysmon"
git clone https://github.com/blmayer/sysmon
cp rebuild-sysmon.sh sysmon
cd sysmon
sed -i 's|PREFIX=${HOME}/.local|PREFIX=/usr|' Makefile
sh rebuild-sysmon.sh

echo
echo
tput setaf 2
echo "################################################################"
echo "################################################################"
echo "################################################################"
echo "COMPARE YOUR CUSTOM CONFIG.DEF.CUSTOM.H WITH CONFIG.DEF.H"
echo "OR ELSE INTRODUCE MISTAKES"
echo "################################################################"
echo "################################################################"
echo "################################################################"
tput sgr0
echo