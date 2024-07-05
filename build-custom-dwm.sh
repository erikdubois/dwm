#!/bin/bash

sudo rm -r dwm
sudo cp -v dwm.desktop /usr/share/xsessions/dwm.desktop
mkdir ~/.config/dwm
cp -v autostart.sh ~/.config/dwm
git clone https://git.suckless.org/dwm
cp -v rebuild.sh dwm
mkdir dwm/patches
cp -v get-patches.sh dwm/patches
cd dwm/patches
sh get-patches.sh
cd ..

#patch < patches/dwm-systray-20230922-9f88553.diff
#sh rebuild.sh
#exit 1

patch < patches/dwm-cfacts-vanitygaps-6.4_combo.diff
patch < patches/dwm-alpha-20230401-348f655.diff
patch < patches/dwm-autostart-20210120-cb3f58a.diff
patch < patches/dwm-bartoggle-6.4.diff

cp -v config.def.h ../config.def.h
cd ..
diff -U 3 config.def.h config.def.custom.h > to-be-changed.diff
cp -v to-be-changed.diff dwm
cd dwm
patch < to-be-changed.diff
sh rebuild.sh
