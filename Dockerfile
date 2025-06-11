ARG BUILDPLATFORM=linux/amd64
FROM --platform=$BUILDPLATFORM ubuntu:latest

# enable 32-bit architecture
RUN dpkg --add-architecture i386

# add WineHQ repository
## install dependancies
RUN apt-get update && apt-get install --no-install-recommends -y \
  ca-certificates \
  wget \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

## Add Wine GPG key
RUN mkdir -pm755 /etc/apt/keyrings
RUN wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key

## add the Wine repository
RUN wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/noble/winehq-noble.sources

# install WineHQ, winetricks
RUN apt update && apt-get install -y --no-install-recommends \
  winehq-stable \
  winetricks \
  && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
  && rm -rf /var/lib/apt/lists/*

# install .NET 4.8
RUN winetricks -q dotnet48 --force \
  && apt-get -y purge winetricks \
  && apt-get -y autoremove
