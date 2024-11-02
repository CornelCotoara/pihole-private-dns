ARG alpine_version="3.20"
ARG S6_OVERLAY_VERSION=3.2.0.2
FROM pihole/pihole:development

RUN apk add -X https://dl-cdn.alpinelinux.org/alpine/${alpine_version} /main -u alpine-keys --allow-untrusted
RUN apk add --no-cache unbound

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

COPY lighttpd-external.conf /etc/lighttpd/external.conf
COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf
COPY start_unbound_and_s6_init.sh start_unbound_and_s6_init.sh

COPY s6/unbound.run /etc/services.d/unbound/run
COPY s6/pihole.run /etc/services.d/pihole/run
RUN chmod +x /etc/services.d/unbound/run
RUN chmod +x /etc/services.d/pihole/run

RUN chmod +x start_unbound_and_s6_init.sh
ENTRYPOINT ./start_unbound_and_s6_init.sh
