#Test ci/cd on devel push!!!
FROM pihole/pihole:latest
RUN apt update && apt install -y unbound

COPY lighttpd-external.conf /etc/lighttpd/external.conf
COPY unbound_tweaked /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf
RUN mkdir -p /etc/services.d/unbound
COPY s6/unbound.run /etc/services.d/unbound/run
RUN chmod +x /etc/services.d/unbound/run
ENTRYPOINT ["/s6-init"]
