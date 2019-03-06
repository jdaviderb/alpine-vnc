FROM alpine:3.9
MAINTAINER Daniel Guerra
ADD /apk /apk
RUN echo "http://alpine.42.fr/latest-stable/main \
		  http://alpine.42.fr/latest-stable/community \
		  http://alpine.42.fr/edge/main \
          http://alpine.42.fr/edge/community " >> /etc/apk/repositories
RUN apk update
RUN apk upgrade
RUN cp /apk/.abuild/-58b83ac3.rsa.pub /etc/apk/keys
RUN apk add /apk/x11vnc-0.9.13-r0.apk
RUN apk add xvfb openbox xfce4-terminal supervisor sudo bash mc nano screen openjdk8 nss-tools openrc openssh openssl xdg-utils tar bash xz binutils xdotool chromium \
	&& addgroup alpine \
	&& adduser  -G alpine -s /bin/sh -D alpine \
	&& echo "alpine:alpine" | /usr/sbin/chpasswd \
	&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers \
	&& rm -rf /apk /tmp/* /var/cache/apk/*
ADD etc /etc
ADD utils /tmp/utils
WORKDIR /tmp/utils

RUN chmod +x /tmp/utils/initialize.sh
RUN dos2unix initialize.sh
CMD ["/tmp/utils/initialize.sh"]

WORKDIR /home/alpine
EXPOSE 5900 5901 5902 5903 22 9229
USER alpine
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
