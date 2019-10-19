RUN rm -rf /etc/rinetd/rinetd.conf
RUN apk add --no-cache supervisor \
    && mkdir -p /etc/supervisord.d
COPY /config/supervisord.conf /etc
COPY /config/process.conf /etc/supervisord.d
COPY /config/rinetd.conf  /etc/rinetd

apk add --no-cache --virtual build-dependencies build-base git autoconf automake
SRC_DIR=/tmp/rinetd
ETC_DIR=/etc/rinetd

git clone https://github.com/samhocevar/rinetd.git /tmp/rinetd
cd /tmp/rinetd
./bootstrap
./configure
make
strip rinetd
install -m700 rinetd /usr/sbin
mkdir /etc/rinetd
install -m644 rinetd.conf /etc/rinetd

cd /
rm -rf /tmp/rinetd
apk del --purge build-dependencies
apk add --no-cache tzdata

RUN apk add --no-cache supervisor \
    && mkdir -p /etc/supervisord.d
COPY /config/supervisord.conf /etc
COPY /config/process.conf /etc/supervisord.d

CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]

/usr/bin/supervisord -c /etc/supervisor.conf

https://github.com/codexss/shadowsocks-rinetd/blob/master/Dockerfile
https://hub.docker.com/r/vimagick/rinetd/  https://github.com/vimagick/dockerfiles/tree/master/rinetd
https://hub.docker.com/r/woahbase/alpine-supervisor/

https://raw.githubusercontent.com/clangcn/kcp-server/master/socks5_latest/socks5_linux_amd64
https://github.com/xtaci/kcptun/releases/latest
