## base
FROM ubuntu:24.04 AS base

ARG KEEPALIVED_VERSION

ENV KEEPALIVED_VERSION=$KEEPALIVED_VERSION
ENV DEBIAN_FRONTEND=noninteractive

## builder
FROM base AS builder
WORKDIR /usr/src/keepalived

RUN apt-get update && apt-get install -y --no-install-recommends \
        git ca-certificates \
        build-essential autoconf automake libtool pkg-config \
        libssl-dev \
        libnl-3-dev libnl-genl-3-dev \
        libnfnetlink-dev \
        libmnl-dev libnftnl-dev \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 --branch ${KEEPALIVED_VERSION} \
        https://github.com/acassen/keepalived.git /usr/src/keepalived

RUN ./autogen.sh \
    && ./configure --prefix=/usr --sysconfdir=/etc \
    && make -j"$(nproc)" \
    && make install DESTDIR=/install \
    && rm -rf /install/etc/keepalived/samples \
              /install/usr/share/man \
              /install/etc/sysconfig


## runner
FROM base AS runner

RUN apt-get update && apt-get install -y --no-install-recommends \
        libssl3t64 \
        libnl-3-200 libnl-genl-3-200 \
        libmnl0 libnftnl11 \
        gettext-base \
        iproute2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /install/ /

COPY keepalived.conf.template /etc/keepalived/keepalived.conf.template
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["--dont-fork", "--log-console"]
