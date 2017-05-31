FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.15.15
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64
ARG FACTORIO_HEADLESS_SHA512=269ece226aa9a5083ee8c8ca3d26b4fa4bc25c902132355058a5027f36578ddea9e2735f50eae25862aa1eb5664ece22852452a6dd45a92e3f963b46a855db3e

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
