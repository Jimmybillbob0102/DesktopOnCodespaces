#!/bin/bash

# Check if kwriteconfig5 is available and disable KDE compositing if kwinrc does not exist
if [ ! -f "$HOME/.config/kwinrc" ]; then
  if command -v kwriteconfig5 >/dev/null 2>&1; then
    kwriteconfig5 --file "$HOME/.config/kwinrc" --group Compositing --key Enabled false
  else
    echo "Error: kwriteconfig5 is not found. Install KDE tools (e.g., 'pacman -S kde-cli-tools')."
  fi
fi

# Check if kwriteconfig5 is available and disable KDE screen locker if kscreenlockerrc does not exist
if [ ! -f "$HOME/.config/kscreenlockerrc" ]; then
  if command -v kwriteconfig5 >/dev/null 2>&1; then
    kwriteconfig5 --file "$HOME/.config/kscreenlockerrc" --group Daemon --key Autolock false
  else
    echo "Error: kwriteconfig5 is not found. Install KDE tools (e.g., 'pacman -S kde-cli-tools')."
  fi
fi

# Prevent console from blanking or powering down if setterm is available
if command -v setterm >/dev/null 2>&1; then
  setterm blank 0
  setterm powerdown 0
else
  echo "Warning: setterm not found. Console blanking and powerdown settings skipped."
fi

# Launch KDE Plasma if startplasma-x11 is available
if command -v startplasma-x11 >/dev/null 2>&1; then
  dbus-launch startplasma-x11 > /dev/null 2>&1 &
else
  echo "Error: startplasma-x11 not found. Please ensure KDE Plasma is installed (e.g., 'pacman -S plasma-desktop')."
fi
