FROM ruby:alpine

RUN apk add --no-cache build-base gcc bash cmake git libffi-dev

# install both bundler 1.x and 2.x
RUN gem install bundler -v "~>1.0" && gem install bundler jekyll

EXPOSE 4000

WORKDIR /srv/jekyll

CMD [ "--help" ]
