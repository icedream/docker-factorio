FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.15.6
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64
ARG FACTORIO_HEADLESS_SHA512=79e66089f74c61016c7284da0e94369125bf200f754ec4ed02e913675aa32571af9063209f6f9180336ce4d505b1227d76eaf81f79e18620eac912e49cc87bcc

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
