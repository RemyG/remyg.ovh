jekyll-build:
	docker build -f docker/jekyll/Dockerfile -t rpi-jekyll .

nginx-build:
	docker build -f docker/nginx/Dockerfile -t rpi-nginx-jekyll .

build:
	docker-compose run site /bin/sh -c "\
		bundle install; \
		jekyll build --destination ../_site"

build-watch:
	docker-compose run -d site /bin/sh -c "\
		bundle install; \
		jekyll build --watch --destination ../_site"

jekyll-serve:
	docker-compose run site /bin/sh -c "\
		bundle install; \
		jekyll serve"

serve-dev:
	docker-compose run -d --service-ports serve-dev

serve-prod:
	docker-compose run -d --service-ports serve-prod
