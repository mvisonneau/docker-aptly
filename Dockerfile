FROM debian:jessie

ENV APTLY_VERSION 0.9.7
ENV DEBIAN_FRONTEND noninteractive

# CONFD
ADD https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 /usr/local/bin/confd
ADD confd /etc/confd

# APTLY INSTALLATION
RUN \
chmod +x /usr/local/bin/confd; \
echo "deb http://repo.aptly.info/ squeeze main" > /etc/apt/sources.list.d/aptly.list; \
apt-key adv --keyserver keys.gnupg.net --recv-keys 9E3E53F19C7DE460; \
apt-get update; \
apt-get -y install apt-transport-s3 aptly=${APTLY_VERSION}; \
apt-get clean; apt-get autoclean; rm -rf /var/lib/apt/lists/*

# CONFIGURE DATA VOLUME
VOLUME "/aptly"

# CONTAINER ENTRYPOINT
ADD docker-entrypoint /docker-entrypoint
ADD docker-entrypoint.d /docker-entrypoint.d
ENTRYPOINT ["/docker-entrypoint"]
