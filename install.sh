#!/bin/bash

# Update and install jq if not already installed (for Arch)
sudo pacman -Sy --noconfirm jq

# Build Docker image
docker build -t desktoponcodespaces . --no-cache

# Create Save directory and copy config files
mkdir -p Save
cp -r root/config/* Save

# Set options.json file path
json_file="options.json"

# Run container with or without KVM based on options.json
if jq ".enablekvm" "$json_file" | grep -q true; then
    docker run -d --name=DesktopOnCodespaces \
        -e PUID=1000 -e PGID=1000 --device=/dev/kvm --security-opt seccomp=unconfined \
        -e TZ=Etc/UTC -e SUBFOLDER=/ -e TITLE=GamingOnCodespaces \
        -p 3000:3000 --shm-size="2gb" \
        -v "$(pwd)/Save:/config" \
        --restart unless-stopped desktoponcodespaces
else
    docker run -d --name=DesktopOnCodespaces \
        -e PUID=1000 -e PGID=1000 --security-opt seccomp=unconfined \
        -e TZ=Etc/UTC -e SUBFOLDER=/ -e TITLE=GamingOnCodespaces \
        -p 3000:3000 --shm-size="2gb" \
        -v "$(pwd)/Save:/config" \
        --restart unless-stopped desktoponcodespaces
fi

# Clear terminal and output message
clear
echo "INSTALL FINISHED! Check Port Tab"
