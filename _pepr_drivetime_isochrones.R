#!/usr/local/bin/Rscript

suppressPackageStartupMessages(library(argparser))
p <- arg_parser('return drive time and distance (m) for geocoded CSV file')
p <- add_argument(p, 'file_name', help = 'name of geocoded csv file')
p <- add_argument(p, 'site', help = 'abbreviation for care center')
args <- parse_args(p)

suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))

selected_site <- args$site
## selected_site <- 'cchmc' # for testing

site_coords <- data.frame(
  site_name = c("childrens_hospital_philadelphia", "riley_childrens_indianapolis", "seattle_childrens",
                "childrens_mercy_kansas", "emory_univ", "johns_hopkins",
                "cleveland_clinic", "levine_childrens_charlotte", "st_louis_childrens",
                "oregon_health_and_science", "univ_michigan_health", "childrens_alabama",
                "cincinnati_childrens", "nationwide_childrens", "ucla"),
  lat = c(39.9470417, 39.7759053, 47.6626378,
          39.0834675, 33.7894903, 39.2946548,
          41.502823, 35.2049751, 38.6374922,
          45.4978355, 42.2820339, 33.5053047,
          39.1404509, 39.9532657, 34.0650959),
  lon = c(-75.1941169, -86.1808182, -122.2854537,
          -94.5793016, -84.3289603, -76.5930753,
          -81.6239107, -80.841092, -90.2674885,
          -122.6882339, -83.7294769, -86.8080575,
          -84.5042517, -82.979289, -118.4485678)
) %>%
  st_as_sf(coords = c('lon', 'lat'), crs=4326) %>%
  st_transform(crs = 5072)

# create named look-up vector
site_names <- c("chop" = "childrens_hospital_philadelphia",
                "riley" = "riley_childrens_indianapolis",
                "seattle" = "seattle_childrens",
                "mercy" = "childrens_mercy_kansas",
                "emory" = "emory_univ",
                "jhu" = "johns_hopkins",
                "cc" = "cleveland_clinic",
                "levine" = "levine_childrens_charlotte",
                "stl" = "st_louis_childrens",
                "ohsu" = "oregon_health_and_science",
                "umich" = "univ_michigan_health",
                "al" = "childrens_alabama",
                "cchmc" = "cincinnati_childrens",
                "nat" = "nationwide_childrens",
                "ucla" = "ucla")

if (! selected_site %in% names(site_names)){
  stop('site argument is invalid or missing; please consult documentation for details', call. = FALSE)
}

message('\nloading and projecting input file...')
raw_data <- suppressMessages(read_csv(args$file_name))
## raw_data <- suppressMessages(read_csv('./my_address_file_geocoded.csv'))

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
isochrones_no_overlap <- readRDS("pepr_isochrones_no_overlap_5072.rds") # 5072 projection

dt_polygons <-
  selected_site %>%
  site_names[[.]] %>%
  isochrones_no_overlap[[.]]

message('\nfinding drive time for each point...')
d <- st_join(d, dt_polygons)

message('\nfinding distance (m) for each point...')

d$distance <-
  st_distance(site_coords %>% filter(site_name == site_names[[selected_site]]),
              d,
              by_element = TRUE)

# remove transformed coords and add back "old" coords
d <- d %>%
  st_set_geometry(NULL) %>%
  rename(lon = old_lon,
         lat = old_lat)

# add back in original missing coords data for output file
out_file <- suppressWarnings(bind_rows(raw_data[!d_cc, ], d))

out_file_name <- paste0(tools::file_path_sans_ext(args$file_name), '_pepr_drivetime_', selected_site, '.csv')

write_csv(out_file, out_file_name)

message('\nFINISHED! output written to ', out_file_name)
