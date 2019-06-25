library(tidyverse)
library(sf)

load(file="pepr_isochrones_no_overlap.Rds")

getDriveTime <- function(file, site) {
  address_data <- read_csv(file=file,
                           col_types = list(fips_tract_id = col_character())) %>% 
    filter(!is.na(lat), !is.na(lon)) %>% 
    st_as_sf(coords = c('lon', 'lat'), crs=4326)
  
  if (site == "CCHMC") {
    dt_polygons <- isochrones_no_overlap[["cincinnati_childrens"]]
  }
  
  drivetime <- st_join(address_data, dt_polygons) %>% 
    as_tibble()
}


cchmc_drivetime <- getDriveTime(file="/Users/RASV5G/OneDrive\ -\ cchmc/__drivetime/my_address_file_geocoded.csv",
                                site="CCHMC")

## how will we have user input site name? 

