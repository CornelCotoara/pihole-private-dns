#Test ci/cd on alfa push!!!
FROM pihole/pihole:v6-alpine-play
ARG S6_OVERLAY_VERSION=3.1.5.1
RUN apk upgrade --update && \
  apk add --no-cache unbound xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
#ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /tmp
COPY lighttpd-external.conf /etc/lighttpd/external.conf
COPY unbound_tweaked /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf
RUN mkdir -p /etc/services.d/unbound
RUN mkdir -p /var/lib/unbound
RUN sh -c 'curl https://www.internic.net/domain/named.root > /var/lib/unbound/root.hints'
#RUN sh -c 'cat /var/lib/unbound/root.hints'
COPY s6/unbound.run /etc/services.d/unbound/run
RUN chmod +x /etc/services.d/unbound/run
ENV IPv6 False
ENTRYPOINT ["/s6-init"]
