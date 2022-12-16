#!/usr/local/bin/Rscript

dht::greeting()

## load libraries without messages or warnings
withr::with_message_sink("/dev/null", library(dplyr))
withr::with_message_sink("/dev/null", library(tidyr))
withr::with_message_sink("/dev/null", library(sf))

doc <- "
      Usage:
      entrypoint.R <filename> <site>
      "

opt <- docopt::docopt(doc)

## for interactive testing
## opt <- docopt::docopt(doc, args = 'test/my_address_file_geocoded.csv')

centers <- readr::read_csv('/app/center_addresses.csv')
selected_site <- opt$site

if (! selected_site %in% centers$abbreviation){
  stop('site argument is invalid or missing; please consult documentation for details', call. = FALSE)
}

message("reading input file...")
d <- dht::read_lat_lon_csv(opt$filename, nest_df = T, sf = T, project_to_crs = 5072)

dht::check_for_column(d$raw_data, "lat", d$raw_data$lat)
dht::check_for_column(d$raw_data, "lon", d$raw_data$lon)

message('loading isochrone shape file...')
isochrones <- readRDS(glue::glue("/app/isochrones/{selected_site}_isochrones.rds")) # 5072 projection

## add code here to calculate geomarkers
message('finding drive time for each point...')
d$d <- suppressWarnings( st_join(d$d, isochrones, largest = TRUE) ) %>% 
  mutate(drive_time = ifelse(!is.na(drive_time), as.character(drive_time), "> 60"))

message('finding distance (m) for each point...')

centers <- centers %>% 
  filter(abbreviation == selected_site) %>% 
  st_as_sf(coords = c('lon', 'lat'), crs = 4326) %>%
  st_transform(5072)

d$d$distance <-
  st_distance(centers,
              d$d,
              by_element = TRUE)

## merge back on .row after unnesting .rows into .row
dht::write_geomarker_file(d = d$d, 
                          raw_data = d$raw_data, 
                          filename = opt$filename,
                          argument = opt$site)

