FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.15.14
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64
ARG FACTORIO_HEADLESS_SHA512=07addf0ef86683c6dff84f73eb4c3360a102f2a80544a6c4987f7a621a82de451b0ee183fd2c82062ff4bd0856459373847e9ece36af7c5ced82a26e1aa2be76

# Unpack and reconfigure Factorio
ADD ${FACTORIO_HEADLESS_URL} /var/tmp/factorio.tar
RUN \
	apt-get update &&\
	apt-get install -y xz-utils &&\
	apt-mark auto xz-utils &&\
	echo "${FACTORIO_HEADLESS_SHA512} /var/tmp/factorio.tar" |\
		sha512sum -c --strict - &&\
	\
	mkdir -p /opt &&\
	tar vxf /var/tmp/*.tar* -C /opt/ &&\
	rm -rf /var/tmp/* /tmp/* &&\
	\
	for f in /opt/factorio/bin/x64/*; do \
		chmod -v +x "$f"; \
	done &&\
	apt-get autoremove -y --purge

# Reconfigure Factorio
COPY config-path.cfg /opt/factorio/config-path.cfg
COPY config /config/

# Create an empty write data folder
WORKDIR /data

VOLUME ["/config", "/data"]

EXPOSE 34197/udp

CMD ["/opt/factorio/bin/x64/factorio", "--start-server-load-latest", "--mod-directory", "./mods"]
