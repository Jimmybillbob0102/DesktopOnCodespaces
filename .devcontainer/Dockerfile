# Stage 1 - Arch base for building specific tools or packages
FROM archlinux:latest AS arch-stage

# Update system and install base-devel, git, vim, and python
RUN pacman -Syu --noconfirm base-devel git vim python

# Stage 2 - Ubuntu Jammy with KasmVNC
FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

# Set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="[Mollomm1 Mod] Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="mollomm1"

# Additional setup
ARG DEBIAN_FRONTEND="noninteractive"

# Prevent Ubuntu's firefox stub from being installed
COPY /root/etc/apt/preferences.d/firefox-no-snap /etc/apt/preferences.d/firefox-no-snap
COPY options.json /
COPY /root/ /

RUN \
  echo "**** install packages ****" && \
  add-apt-repository -y ppa:mozillateam/ppa && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y firefox jq wget && \
  chmod +x /install-de.sh && \
  /install-de.sh

RUN \
  chmod +x /installapps.sh && \
  /installapps.sh && \
  rm /installapps.sh

RUN \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# Ports and volumes
EXPOSE 3000
VOLUME /config
