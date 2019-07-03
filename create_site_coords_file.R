library(tidyverse)
library(sf)

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

saveRDS(site_coords, "site_coords.Rds")
