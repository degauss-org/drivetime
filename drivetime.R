#!/usr/local/bin/Rscript

dht::greeting(geomarker_name = 'drivetime', version = '1.0', description = 'calculates drivetime to specified care center')

suppressPackageStartupMessages(library(argparser))
p <- arg_parser('return drive time and distance (m) for geocoded CSV file')
p <- add_argument(p, 'file_name', help = 'name of geocoded csv file')
p <- add_argument(p, 'site', help = 'abbreviation for care center')
args <- parse_args(p)

old_warn <- getOption("warn")
options(warn = -1)

suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))

options(warn = old_warn)

centers <- read_csv('/app/center_addresses.csv')
# centers <- read_csv('center_addresses.csv')

selected_site <- args$site
## selected_site <- 'cchmc' # for testing

if (! selected_site %in% centers$abbreviation){
  stop('site argument is invalid or missing; please consult documentation for details', call. = FALSE)
}

message('\nloading and projecting input file...')
raw_data <- suppressMessages(read_csv(args$file_name))
## raw_data <- suppressMessages(read_csv('test/my_address_file_geocoded.csv'))

d_cc <- complete.cases(raw_data[ , c('lat','lon')])

if (! all(d_cc)) {
  message('\nWARNING: input file contains ', sum(!d_cc), ' rows with missing coordinates.')
  message('\nWill return NA for drive time and distance for these rows.')
}

d <- raw_data[d_cc, ]

# store coords as separate numeric columns because
# trans and back trans lead to rounding errors, making them unsuitable for merging
d$old_lat <- d$lat
d$old_lon <- d$lon

d <- d %>%
  st_as_sf(coords = c('lon', 'lat'), crs = 4326) %>%
  st_transform(5072)

message('\nloading isochrone shape files...')
isochrones_no_overlap <- readRDS("/app/isochrones_no_overlap.rds") # 5072 projection
# isochrones_no_overlap <- readRDS("isochrones_no_overlap.rds")

dt_polygons <-
  selected_site %>%
  isochrones_no_overlap[[.]]

message('\nfinding drive time for each point...')
d <- st_join(d, dt_polygons) %>% 
  mutate(drive_time = ifelse(!is.na(drive_time), as.character(drive_time), "> 60"))

message('\nfinding distance (m) for each point...')

centers <- centers %>% 
  st_as_sf(coords = c('lon', 'lat'), crs = 4326) %>%
  st_transform(5072)

d$distance <-
  st_distance(centers %>% filter(abbreviation == selected_site),
              d,
              by_element = TRUE)

# remove transformed coords and add back "old" coords
d <- d %>%
  st_set_geometry(NULL) %>%
  rename(lon = old_lon,
         lat = old_lat)

# add back in original missing coords data for output file
out_file <- suppressWarnings(bind_rows(raw_data[!d_cc, ], d))

out_file_name <- paste0(tools::file_path_sans_ext(args$file_name), '_drivetime_v1.0_', selected_site, '.csv')

write_csv(out_file, out_file_name)

message('\nFINISHED! output written to ', out_file_name)
