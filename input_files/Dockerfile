## This Dockerfile builds an image that will scan a supplied Dockerfile and a Docker image from Docker repository

FROM debian:latest
VOLUME ["/results"]
COPY *.sh /
RUN chmod +x tools_install_deb.sh entrypoint.sh && ./tools_install_deb.sh
ENTRYPOINT ["/entrypoint.sh"]
