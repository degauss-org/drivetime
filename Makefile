.PHONY: build test test-choablank test-cmhh test-nypcolumbia test-nypcornell shell clean

build:
	docker build -t drivetime .

# default single test
#	docker run --rm -v "${PWD}/test":/tmp drivetime my_address_file_geocoded.csv cchmc

test:	test-choablank test-cmhh test-nypcolumbia test-nypcornell

test-choablank: 
	docker run --rm -v "${PWD}/test":/tmp drivetime my_address_file_geocoded_drivetime_choablank.csv choablank

test-cmhh: 
	docker run --rm -v "${PWD}/test":/tmp drivetime my_address_file_geocoded_drivetime_cmhh.csv cmhh

test-nypcolumbia: 
	docker run --rm -v "${PWD}/test":/tmp drivetime my_address_file_geocoded_drivetime_nypcolumbia.csv nypcolumbia

test-nypcornell:
	docker run --rm -v "${PWD}/test":/tmp drivetime my_address_file_geocoded_drivetime_nypcornell.csv nypcornell

shell:
	docker run --rm -it --entrypoint=/bin/bash -v "${PWD}/test":/tmp drivetime

clean:
	docker system prune -f
