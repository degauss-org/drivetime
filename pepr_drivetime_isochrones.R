library(tidyverse)
library(sf)

# load in isochrone shape file
load(file="pepr_isochrones_no_overlap_5072.Rds") # 5072 projection

# create named look-up vector 
site_names <- c("chop" = "childrens_hospital_philadelphia", 
                "riley" = "riley_childrens_indianapolis", 
                "seattle" = "seattle_childrens", 
                "mercy" = "childrens_mercy_kansas",  # cmh
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
)

site_coords <- site_coords %>% 
  filter(!is.na(lat), !is.na(lon)) %>% 
  st_as_sf(coords = c('lon', 'lat'), crs=4326) %>% 
  st_transform(crs=5072)

# site_coords[site_coords$site_name==site_names["chop"],]



getDriveTimeDistance <- function(file, site) {
  if (!site %in% names(site_names)) {
    print("Site name abbreviation entered does not match any of the sites. See the GitHub ReadMe for a list site abbreviations.")
  }
  
  address_data <- read_csv(file=file,
                           col_types = list(fips_tract_id = col_character())) 
  
  address_data_sf <- address_data %>% 
    filter(!is.na(lat), !is.na(lon)) %>% 
    st_as_sf(coords = c('lon', 'lat'), crs=4326) %>% 
    st_transform(crs=5072) # change to match isochrones
  
  site_name_list <- site_names[[site]]
  dt_polygons <- isochrones_no_overlap[[site_name_list]]
  
  drivetime <- st_join(address_data_sf, dt_polygons) %>% 
    as_tibble() %>% 
    select(-geometry)
  
  drive_distance <- st_distance(site_coords[site_coords$site_name==site_names[site],], address_data_sf)
  
  address_data_dist <- address_data_sf %>% 
    as_tibble() %>% 
    mutate(distance = t(drive_distance)) %>% 
    left_join(drivetime) %>% 
    select(-geometry) %>% 
    rename(distance_m = distance)
  
  adds_na_bind <- address_data %>% 
    filter(!id %in% address_data_dist$id) %>% 
    mutate(drive_time = NA,
           distance_m = NA) %>% 
    select(-lat, -lon)
  
  drivetime_distance <- rbind(adds_na_bind, address_data_dist)
}


cchmc_drivetime <- getDriveTimeDistance(file="/Users/RASV5G/OneDrive\ -\ cchmc/__drivetime/my_address_file_geocoded.csv",
                                site="cchmc")

# intentionally entered site name abbreviation incorrectly to throw error
cchmc_drivetime <- getDriveTimeDistance(file="/Users/RASV5G/OneDrive\ -\ cchmc/__drivetime/my_address_file_geocoded.csv",
                                site="chmc")

