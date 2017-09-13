FROM arm32v6/alpine:3.6

MAINTAINER Remy Gardette <contact@remyg.fr>

ENV JEKYLL_VERSION=3.5.2

RUN apk update \
	&& apk add ruby ruby-dev curl ca-certificates build-base libffi-dev ruby-json \
	&& rm -rf /var/cache/apk/*

RUN update-ca-certificates

RUN addgroup -Sg 1000 jekyll
RUN adduser  -Su 1000 -G \
        jekyll jekyll

RUN gem install bundler --no-rdoc --no-ri
RUN gem install jekyll --no-rdoc --no-ri

RUN mkdir -p /srv/jekyll && chown -R jekyll:jekyll /srv/jekyll
RUN echo 'jekyll ALL=NOPASSWD:ALL' >> /etc/sudoers

WORKDIR /srv/jekyll/site

CMD [ "jekyll", "--help" ]
VOLUME /srv/jekyll
