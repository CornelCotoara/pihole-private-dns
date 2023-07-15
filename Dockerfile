#Test ci/cd on alfa push!!!
FROM pihole/pihole:v6-alpine-play
RUN apk update && apk install unbound
COPY lighttpd-external.conf /etc/lighttpd/external.conf
COPY unbound_tweaked /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf
RUN mkdir -p /etc/services.d/unbound
RUN sh -c 'curl https://www.internic.net/domain/named.root > /var/lib/unbound/root.hints'
#RUN sh -c 'cat /var/lib/unbound/root.hints'
COPY s6/unbound.run /etc/services.d/unbound/run
RUN chmod +x /etc/services.d/unbound/run
ENV IPv6 False
ENTRYPOINT ["/s6-init"]
