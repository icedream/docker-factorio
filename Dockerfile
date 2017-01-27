FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.14.21
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64

# Unpack and reconfigure Factorio
ADD ${FACTORIO_HEADLESS_URL} /var/tmp/factorio.tar.gz
RUN \
	mkdir -p /opt &&\
	tar vxf /var/tmp/*.tar* -C /opt/ &&\
	rm -rf /var/tmp/* /tmp/* &&\
	\
	for f in /opt/factorio/bin/x64/*; do \
		chmod -v +x "$f"; \
	done

# Reconfigure Factorio
COPY config-path.cfg /opt/factorio/config-path.cfg
COPY config /config/

# Create an empty write data folder
WORKDIR /data

VOLUME ["/config", "/data"]

EXPOSE 34197/udp

CMD ["/opt/factorio/bin/x64/factorio", "--start-server-load-latest", "--mod-directory", "./mods"]
