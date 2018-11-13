FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.16.36
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64
ARG FACTORIO_HEADLESS_SHA512=b91fa3a779f9d971a7b7bc59466b7cf194927c59d52f31449abae85fcdb0e0bb048527a75b8c03e374556163607a7eadd95fec25c41e92168a0eff693d2cbc8e

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
