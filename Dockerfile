FROM alpine:latest
RUN apk --update --no-cache add bash \
    && mkdir -p /home/work
COPY /config /home/work

RUN set -x && \
    chown root:root /home/work/* && \
    chmod 755 /home/work/* && \
    ln -s /home/work/kcp-server /bin/kcp-server && \
    ln -s /home/work/socks5 /bin/socks5

# install rinetd
COPY /config/rinetd-bbr /usr/local/bin
COPY /config/rinetd.conf /etc
RUN set -ex \
    # Install dependencies
    && apk add --no-cache iptables \
    && chmod +x /usr/local/bin/rinetd-bbr


# install supervisor
RUN apk --update add --no-cache supervisor \
    && mkdir -p /etc/supervisord.d
COPY /config/supervisord.conf /etc
COPY /config/process.conf /etc/supervisord.d
STOPSIGNAL SIGTERM
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
