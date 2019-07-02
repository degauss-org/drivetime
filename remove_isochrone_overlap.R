library(tidyverse)
library(sf)
library(fs)

isochrone_files <- dir_ls(path="./isochrones")

isochrones <- map(isochrone_files, st_read)
names(isochrones) <- substr(names(isochrones), 25, nchar(names(isochrones)))
names(isochrones) <- str_replace(names(isochrones), ".geojson", "")
isochrones <- map(isochrones, st_transform, crs=5072) # reproject

# work with cchmc for a bit
cchmc <- isochrones[["cincinnati_childrens"]]

cchmc <- cchmc %>% 
  mutate(value = as.factor(value/60))

p <- list()
p[[1]] <- cchmc[1,]
for(i in 2:nrow(cchmc)) {
  p[[i]] <- st_difference(cchmc[i,], cchmc[i-1,]) %>% 
    select(group_index:center, geometry)
}
cchmc_no_overlap <- do.call(rbind, p) 

ggplot() + 
  geom_sf(data = cchmc_no_overlap, aes(fill =  value), alpha=0.8) +
  scale_fill_brewer(palette = "RdYlGn", direction = -1)

# do for all sites
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

# test one
tmp <- isochrones_no_overlap[["seattle_childrens"]]
ggplot() + 
  geom_sf(data = tmp, aes(fill =  drive_time), alpha=0.8) +
  scale_fill_brewer(palette = "RdYlGn", direction = -1)

save(isochrones_no_overlap, file="pepr_isochrones_no_overlap_5072.Rds")

