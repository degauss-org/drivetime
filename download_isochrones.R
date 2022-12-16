library(tidyverse)
library(sf)
library(openrouteservice) # remotes::install_github("GIScience/openrouteservice-r")

# read in geocoded facilities data
centers <- read_csv("center_addresses.csv") %>% 
  arrange(abbreviation)

# download isochrones from ORS
get_isochrones <- function(x) {
  ors_isochrones(centers[x, c('lon', 'lat')],
                 profile = 'driving-car',
                 range = 60*60,   
                 interval = 6*60,
                 output = "sf") %>%
    st_transform(5072)
}

# ex <- get_isochrones(1)
# ggplot() + 
#   geom_sf(data = ex[2,]) +
#   geom_sf(data = ex[1,]) 

isochrones <- mappp::mappp(1:nrow(centers), get_isochrones)

saveRDS(isochrones, 'isochrones/isochrones.rds')
# isochrones <- readRDS('drivetime_distance/cf_isochrones.rds')

removeOverlap <- function(x) {
  x <- x %>%
    mutate(drive_time = as.factor(value/60)) %>%
    select(drive_time, geometry)
  p <- list()
  p[[1]] <- x[1,]
  for(i in 2:nrow(x)) {
    p[[i]] <- st_difference(x[i,], x[i-1,]) %>%
      select(drive_time, geometry)
  }
  do.call(rbind, p)
}

isochrones_no_overlap <- map(isochrones, removeOverlap)
names(isochrones_no_overlap) <- centers$abbreviation
saveRDS(isochrones_no_overlap, 'isochrones_no_overlap.rds')

purrr::walk(1:length(isochrones_no_overlap),
           ~saveRDS(isochrones_no_overlap[[.x]], 
                    glue::glue('isochrones/{names(isochrones_no_overlap)[.x]}_isochrones.rds')))


