ARG DEBIAN_VER

FROM debian:${DEBIAN_VER}

ARG APP
ARG APP_VER
ARG DEBIAN_VER
ARG LITECOIN_VER

# Add metadata.
ENV APP=${APP} \
    APP_VER=${APP_VER} \
    DEBIAN_VER=${DEBIAN_VER} \
    LITECOIN_VER=${LITECOIN_VER} \
    LITECOIN_DATA=/home/litecoin/.litecoin

LABEL org.opencontainers.image.authors="davidlukac@users.noreply.github.com" \
      org.opencontainers.image.version=${APP_VER} \
      version=${APP_VER} \
      application=${APP} \
      debian-version=${DEBIAN_VER} \
      litecoin-version=${LITECOIN_VER}

# Apply security patches.
RUN sh -c 'grep security /etc/apt/sources.list | tee /etc/apt/security.sources.list' && \
    apt-get -y update && \
    apt-get -y upgrade -o Dir::Etc::SourceList=/etc/apt/security.sources.list && \
    apt-get -y upgrade \
      libgcrypt20 && \
    apt-get clean && \
    apt-get autoclean && \
    apt-get autoremove --purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY build/litecoin/litecoin* /usr/local/bin

VOLUME ["/home/litecoin/.litecoin"]

# Expose only mainnet ports.
EXPOSE 9332 9333

# Run as non-root user.
RUN adduser --disabled-password --uid 1001 --gecos "" litecoin

USER litecoin

CMD ["litecoind"]
