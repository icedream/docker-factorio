FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.14.22
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64
ARG FACTORIO_HEADLESS_SHA512=5beff2a14559e5845fc02e9d74d7fcc98d1f51d47ed8dfb95461ec5813a984c768dc05939fa0d9b97d37f04fc1348c2e5f0e10a8b4dcfe6eeb81f013cf98ca37

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
