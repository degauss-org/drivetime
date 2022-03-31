.PHONY: build test shell clean

build:
	docker build -t drivetime .

test:
	docker run --rm -v "${PWD}/test":/tmp drivetime my_address_file_geocoded.csv cchmc

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp drivetime

clean:
	docker system prune -f