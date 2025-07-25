# Pull base image.
FROM jlesage/baseimage-gui:debian-11-v4

ENV USER_ID=0 GROUP_ID=0 TERM=xterm

ARG MEDIATHEK_VERSION=14.2.0

# Define working directory.
WORKDIR /tmp

# Install dependencies.
# Run deps
RUN \
    apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
        apt-utils \
        locales \
        wget \
        ffmpeg \
        vlc \
	    flvstreamer \
    && apt-get remove samba \
    && apt-get clean

RUN echo en_US.UTF-8 UTF-8 > /etc/locale.gen
RUN locale-gen
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8


# Define software download URLs.
ARG MEDIATHEKVIEW_URL=https://download.mediathekview.de/stabil/MediathekView-$MEDIATHEK_VERSION-linux.tar.gz
#ARG FFMPEG_URL=https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz
#ARG FFMPEG_VERSION=4.2.2

# install ffmpeg
#RUN mkdir -p /opt/ffmpeg
#RUN wget -q ${FFMPEG_URL} -O ffmpeg.tar.xz
#RUN tar xf ffmpeg.tar.xz -C /opt/ffmpeg
# Mediathekview only searches in /usr/bin for binaries like ffmpeg and vlc...
#RUN ln -s /opt/ffmpeg/ffmpeg-${FFMPEG_VERSION}-amd64-static/ffmpeg /usr/bin/
#RUN ln -s /opt/ffmpeg/ffmpeg-${FFMPEG_VERSION}-amd64-static/ffprobe /usr/bin/

# download Mediathekview
RUN mkdir -p /opt/MediathekView
RUN wget -q ${MEDIATHEKVIEW_URL} -O MediathekView.tar.gz
RUN tar xf MediathekView.tar.gz -C /opt

# Maximize only the main/initial window.
#RUN \
#    sed-patch 's/<application type="normal">/<application type="normal" title="Mediathekview">/' \
#        /etc/xdg/openbox/rc.xml

COPY src/startapp.sh /startapp.sh

# clear temporary build directory
RUN rm /tmp/*

# Set environment variables.
ENV APP_NAME="Mediathekview" \
    S6_KILL_GRACETIME=8000

# Define mountable directories.
VOLUME ["/config"]
VOLUME ["/output"]

# Metadata.
LABEL \
      org.label-schema.name="mediathekview" \
      org.label-schema.description="Docker container for Mediathekview" \
      org.label-schema.version="unknown" \
      org.label-schema.vcs-url="https://github.com/bate/docker-mediathekview-webinterface" \
      org.label-schema.schema-version="1.0"
