FROM alpine:3.9
MAINTAINER Daniel Guerra
RUN echo "http://alpine.42.fr/v3.9/main" >> /etc/apk/repositories
RUN echo "http://alpine.42.fr/v3.9/community" >> /etc/apk/repositories
RUN echo "http://alpine.42.fr/edge/main" >> /etc/apk/repositories
RUN echo "http://alpine.42.fr/edge/community" >> /etc/apk/repositories
RUN apk update
RUN apk upgrade

RUN apk add x11vnc xvfb openbox xfce4-terminal supervisor sudo \
&& addgroup alpine \
&& adduser  -G alpine -s /bin/sh -D alpine \
&& echo "alpine:alpine" | /usr/sbin/chpasswd \
&& echo "alpine    ALL=(ALL) ALL" >> /etc/sudoers \
COPY etc/supervisord.conf /etc/supervisord.conf
WORKDIR /home/alpine
EXPOSE 5900
USER alpine
CMD ["/usr/bin/supervisord","-c","/etc/supervisord.conf"]
