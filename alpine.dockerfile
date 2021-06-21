ARG ALPINE_VER

FROM alpine:${ALPINE_VER}

ARG APP
ARG APP_VER
ARG GLIBC_VER
ARG LITECOIN_VER

ENV APP=${APP} \
    APP_VER=${APP_VER} \
    GLIBC_VER=${GLIBC_VER} \
    LITECOIN_VER=${LITECOIN_VER} \
    LITECOIN_DATA=/home/litecoin/.litecoin

LABEL org.opencontainers.image.authors="davidlukac@users.noreply.github.com"
LABEL version=${APP_VER}

COPY build/litecoin/litecoin* /usr/local/bin
COPY build/glibc/sgerrand.rsa.pub /etc/apk/keys/sgerrand.rsa.pub
COPY build/glibc/glibc-${GLIBC_VER}.apk /opt/
COPY build/glibc/glibc-bin-${GLIBC_VER}.apk /opt/

# hadolint ignore=DL3018
RUN apk add --no-progress --no-cache \
      /opt/glibc-${GLIBC_VER}.apk \
      /opt/glibc-bin-${GLIBC_VER}.apk && \
    rm -rf /var/cache/apk/* && \
    rm /opt/glibc-*

VOLUME ["/home/litecoin/.litecoin"]
EXPOSE 9332 9333

RUN adduser -D -u 1001 litecoin

USER litecoin

CMD ["litecoind"]
