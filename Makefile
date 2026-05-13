.PHONY: build test test-cmhmc test-choablank shell clean

build:
	docker build -t drivetime .

# original test kept as its own target
test-cmhmc:
	docker run --rm -v "${PWD}/test":/tmp drivetime my_address_file_geocoded.csv cchmc

# new test
test-choablank:
	docker run --rm -v "${PWD}/test":/tmp drivetime my_address_file_geocoded_drivetime_choablank.csv choablank

# aggregate test target
test: test-cmhmc test-choablank

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp drivetime

clean:
	docker system prune -f
