FROM debian:jessie-slim

ARG FACTORIO_VERSION=0.13.20
ARG FACTORIO_HEADLESS_URL=https://www.factorio.com/get-download/${FACTORIO_VERSION}/headless/linux64
ARG FACTORIO_HEADLESS_SHA512=ec2f0dcfff8e0adc5871094b14e172d451e1e49caed07bba573ffa1a2ea834796e2a5f9604c6992d6ecf1a3fa0419fcfae8968434f9b7b4a7b8197b43807de70

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
