FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.17.51
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64
ARG FACTORIO_HEADLESS_SHA512=f46e4cfe356d5afd03cdcdc163efdd14f0728057ac5b20eaac2f31e069d0770e7bb69d274440f2bc4cf290f6067e17a9efc3fd425937cd7dec4d1f2a6522aa74

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
