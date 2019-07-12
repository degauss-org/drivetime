library(tidyverse)
library(sf)
library(fs)

isochrones <-
  dir_ls(path = "./isochrones") %>%
  map(st_read) %>%
  map(st_transform, crs = 5072)

names(isochrones) <-
  names(isochrones) %>%
  path_file() %>%
  path_ext_remove() %>%
  str_replace(fixed('isochrones_'), '')

# remove overlap for all sites
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

saveRDS(isochrones_no_overlap, file = "pepr_isochrones_no_overlap_5072.rds")

