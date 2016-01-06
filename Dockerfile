FROM armv7/armhf-ubuntu:14.04.2
MAINTAINER Florian Barth

RUN apt-get update \
	&& apt-get install -y \
						wget \
						supervisor \
						apt-transport-https \
						liblzo2-2 \
						libpython-stdlib \
						libpython2.7-minimal \
						libpython2.7-stdlib \
						python \
						python-minimal \
						python2.7 \
						python2.7-minimal \
	&& apt-get clean \
	&& rm -rf /etc/apt/lists/*
	
RUN wget -O /tmp/p7zip-full.deb https://launchpad.net/~ubuntu-security/+archive/ubuntu/ppa/+build/7596758/+files/p7zip-full_9.20.1~dfsg.1-4+deb7u1build0.14.04.1_armhf.deb \
	&& dpkg -i /tmp/p7zip-full.deb \
	&& rm /tmp/p7zip-full.deb
	
RUN wget -O /tmp/python-lzo.deb https://launchpad.net/ubuntu/+archive/primary/+files/python-lzo_1.08-1_armhf.deb \
	&& dpkg -i /tmp/python-lzo.deb \
	&& rm /tmp/python-lzo.deb
	
RUN wget https://homegear.eu/packages/Release.key \
	&& apt-key add Release.key \
	&& rm Release.key \
	&& echo 'deb https://homegear.eu/packages/Ubuntu/ trusty/' >> /etc/apt/sources.list.d/homegear.list \
	&& apt-get update \
	&& apt-get install -y homegear \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN sed -i 's/db.sql/db\/db.sql/g' /etc/homegear/main.conf \
	&& rm /var/lib/homegear/db.sql
	
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY homegear.conf /etc/supervisor/conf.d/homegear.conf

VOLUME ["/var/lib/homegear/db", "/var/log/homegear"]

EXPOSE 2001 9001

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]

