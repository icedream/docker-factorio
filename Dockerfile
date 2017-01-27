FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.12.35
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64
ARG FACTORIO_HEADLESS_SHA512=0333b25ab8e690bc2e923e2d39c9585f7d6b1d928c0347038741e3a5ccc444598723e9559b0f2a9ef2defcdf6a8f67d696ffcbea730142862d45c1661d653380

# Unpack and reconfigure Factorio
ADD ${FACTORIO_HEADLESS_URL} /var/tmp/factorio.tar.gz
RUN \
	echo "${FACTORIO_HEADLESS_SHA512} /var/tmp/factorio.tar.gz" |\
		sha512sum -c --strict - &&\
	\
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
