#!/bin/bash

# install packages
sudo pacman -S --noconfirm sxhkd
sudo pacman -S --noconfirm go

# File management
sudo rm -r dwm
sudo rm -r sysmon
sudo cp -v dwm.desktop /usr/share/xsessions/dwm.desktop
mkdir ~/.config/dwm
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
patch < patches/dwm-cfacts-vanitygaps-6.4_combo.diff
patch < patches/dwm-alpha-20230401-348f655.diff
patch < patches/dwm-autostart-20210120-cb3f58a.diff
patch < patches/dwm-bartoggle-6.4.diff
patch < patches/dwm-alwayscenter-20200625-f04cac6.diff
# personal patching as official did not work
patch < patched-patches/dwm-cyclelayouts-2024-07-06.diff 

# failed
#patch < patches/dwm-restartsig-20180523-6.2.diff

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
