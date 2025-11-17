FROM ubuntu:24.04

RUN apt update && \
    apt install -y keepalived gettext-base iproute2 && \
    rm -rf /var/lib/apt/lists/*

COPY keepalived.conf.template /etc/keepalived/keepalived.conf.template
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["--dont-fork", "--log-console"]