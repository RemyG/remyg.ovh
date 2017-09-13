FROM hypriot/rpi-alpine-scratch:v3.4

RUN apk update \
	&& apk upgrade \
	&& apk add nginx \
	&& rm -rf /var/cache/apk/*

###############
# nginx
###############

RUN rm /etc/nginx/nginx.conf

RUN chown -R nginx:www-data /var/lib/nginx

ADD root /

RUN mkdir /tmp/conf_override

VOLUME ["/tmp/conf_override"]

RUN mkdir /var/www/jekyll

WORKDIR /etc/nginx

EXPOSE 80 443

CMD ["/bin/sh", "/start-nginx.sh"]
