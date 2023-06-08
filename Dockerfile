#Test ci/cd on devel push!
#
FROM pihole/pihole:2023.05.2
RUN apt update && apt install -y unbound
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
