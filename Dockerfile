FROM pihole/pihole:latest
RUN apt update && apt install -y unbound
#get root.hints
RUN curl https://www.internic.net/domain/named.root -o /etc/unbound/unbound.conf.d/root.hints
RUN echo "net.core.rmem_max=1048576" >> /etc/sysctl.conf
RUN echo "net.core.wmem_max=1048576" >> /etc/sysctl.conf
#COPY root.hints /var/lib/unbound/root.hints

COPY lighttpd-external.conf /etc/lighttpd/external.conf
#COPY unbound-pihole.conf /etc/unbound/unbound.conf.d/pi-hole.conf
COPY test /etc/unbound/unbound.conf.d/pi-hole.conf
COPY 99-edns.conf /etc/dnsmasq.d/99-edns.conf
COPY start_unbound_and_s6_init.sh start_unbound_and_s6_init.sh

RUN chmod +x start_unbound_and_s6_init.sh
ENTRYPOINT ./start_unbound_and_s6_init.sh
