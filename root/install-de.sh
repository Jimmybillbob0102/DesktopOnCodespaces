#!/bin/bash

# Ensure jq and pacman are available
if ! command -v jq >/dev/null 2>&1; then
  echo "Error: jq is not installed. Exiting."
  exit 1
fi
if ! command -v pacman >/dev/null 2>&1; then
  echo "Error: pacman is not available. Exiting."
  exit 1
fi

# Sync package database and update system before installations
echo "Updating package database..."
pacman -Syu --noconfirm

# Install packages based on desktop environment selection in options.json
DE=$(jq -r ".DE" "/options.json")

case "$DE" in
  "KDE Plasma (Heavy)")
    echo "Installing KDE Plasma environment..."
    pacman -S --noconfirm --needed \
      dolphin \
      gwenview \
      kde-gtk-config \
      kdialog \
      kfind \
      khotkeys \
      kio-extras \
      konsole \
      ksystemstats \
      kwin \
      kwrite \
      plasma-desktop \
      plasma-workspace \
      systemsettings
    sed -i 's/applications:org.kde.discover.desktop,/applications:org.kde.konsole.desktop,/g' \
      /usr/share/plasma/plasmoids/org.kde.plasma.taskmanager/contents/config/main.xml
    cp /startwm-kde.sh /defaults/startwm.sh
    ;;

  "XFCE4 (Lightweight)")
    echo "Installing XFCE4 environment..."
    pacman -S --noconfirm --needed \
      firefox \
      mousepad \
      xfce4-terminal \
      xfce4 \
      xdg-user-dirs \
      xfce4-goodies
    rm -f /etc/xdg/autostart/xscreensaver.desktop
    cp /startwm-xfce.sh /defaults/startwm.sh
    ;;

  "I3 (Very Lightweight)")
    echo "Installing i3 window manager environment..."
    pacman -S --noconfirm --needed \
      firefox \
      i3 \
      i3-wm \
      st
    update-alternatives --set x-terminal-emulator /usr/bin/st
    cp /startwm-i3.sh /defaults/startwm.sh
    ;;

  *)
    echo "Error: Unknown desktop environment specified in /options.json. Exiting."
    exit 1
    ;;
esac

# Make the startwm.sh script executable and clean up
chmod +x /defaults/startwm.sh
rm -f /startwm-kde.sh /startwm-i3.sh /startwm-xfce.sh
echo "Installation and configuration completed."
