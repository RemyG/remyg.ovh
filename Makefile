# -----------------------------------------------------------------
#        Main targets
# -----------------------------------------------------------------

## Show this help
help:
	@awk '/^#/{c=substr($$0,3);next}c&&/^[[:alpha:]][[:alnum:]_-]+:/{print substr($$1,1,index($$1,":")),c}1{c=0}' $(MAKEFILE_LIST) | column -s: -t

## Run Jekyll bundle update
bundle:
	docker compose up -d bundle

## Run Jekyll build
build:
	docker compose up -d build

## Serve Jekyll
serve:
	docker compose up -d serve

## Follow logs of docker services
logs:
	docker compose logs -f

## Cleanup containers and attached volumes
clean:
	docker compose down --volumes --remove-orphans