FROM ghcr.io/linuxserver/baseimage-selkies:ubuntunoble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG PCSX2_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thelamer"

# title
ENV TITLE=PCSX2

RUN \
  echo "**** add icon ****" && \
  curl -o \
    /usr/share/selkies/www/icon.png \
    https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/pcsx2-logo.png && \
  echo "**** install packages ****" && \
  apt-key adv \
    --keyserver hkp://keyserver.ubuntu.com:80 \
    --recv-keys D7B449CFE17E659E5A12EE8EDD6EEEA2BD747717 && \
  echo \
    "deb https://ppa.launchpadcontent.net/pcsx2-team/pcsx2-daily/ubuntu noble main" > \
    /etc/apt/sources.list.d/pcsx2.list && \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive \
  apt-get install --no-install-recommends -y \
    libqt6svg6 \
    pcsx2-stable && \
  setcap -r \
    /usr/bin/pcsx2-qt && \
  echo "**** cleanup ****" && \
  apt-get autoclean && \
  rm -rf \
    /config/.cache \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3000

VOLUME /config
