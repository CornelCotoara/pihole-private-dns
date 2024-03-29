FROM pihole/pihole:latest
RUN apt update && apt install -y unbound

COPY lighttpd-external.conf /etc/lighttpd/external.conf
COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf
COPY start_unbound_and_s6_init.sh start_unbound_and_s6_init.sh
#RUN echo 'RATE_LIMIT=2000/60' >> /etc/pihole/pihole-FTL.conf

RUN chmod +x start_unbound_and_s6_init.sh
ENTRYPOINT ./start_unbound_and_s6_init.sh
