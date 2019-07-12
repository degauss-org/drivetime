#!/usr/bin/Rscript


suppressPackageStartupMessages(library(argparser))
p <- arg_parser('return drive time and distance (m) for geocoded CSV file')
p <- add_argument(p,'file_name',help='name of geocoded csv file')
p <- add_argument(p,'site',help='abbreviation for care center')
args <- parse_args(p)

suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(readr))

selected_site <- args$site
# selected_site <- 'cchmc' # for testing

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
  message('\nERROR: site argument is invalid or missing') 
 # message('\ncontinuing with year set to 2010')               ## should I enter a default??
  message('\nplease see the documentation for details')
  selected_site <- NULL
}

message('\nloading and projecting input file...')
d <- read.csv(args$file_name,stringsAsFactors=FALSE)
d_orig <- d

d_cc <- complete.cases(d[ ,c('lat','lon')])

if (! all(d_cc)) {
  n_rows_missing <- nrow(d) - nrow(d[d_cc,])
  message('WARNING: input file contains ', n_rows_missing, ' rows with missing coordinates.')
  message('\nWill return NA for drive time and distance for these rows.')
  d <- d[d_cc, ]
}

# store coords as separate numeric columns because
# trans and back trans lead to rounding errors, making them unsuitable for merging
d$old_lat <- d$lat
d$old_lon <- d$lon

d %<>%
  st_as_sf(coords=c('lon', 'lat'), crs=4326) %>%
  st_transform(5072)

message('\nloading isochrone shape files...')
load(file="pepr_isochrones_no_overlap_5072.Rds") # 5072 projection
site_coords <- readRDS(file="site_coords.Rds") # 5072 proj of site lat/lon

site_name_list <- site_names[[selected_site]]
dt_polygons <- isochrones_no_overlap[[site_name_list]]
 
message('\nfinding drive time for each point...') 
drivetime <- st_join(d, dt_polygons)
 
message('\nfinding distance (m) for each point...') 
distance <- st_distance(site_coords[site_coords$site_name==site_names[selected_site],], drivetime)
  
# transform to dataframe
# remove transformed coords
# add back "old" coords
drivetime_distance <- drivetime %>%
  mutate(distance = as.numeric(t(distance))) %>% 
  st_set_geometry(NULL) %>%
  rename(lon = old_lon,
         lat = old_lat)
  
d_na <- d_orig[!d_cc, ] %>% 
  mutate(drive_time = NA,
         distance = NA)
  
out.file <- bind_rows(d_na, drivetime_distance)

out.file.name <- paste0(gsub('.csv','',args$file_name,fixed=TRUE),'_pepr_drivetime_', selected_site, '.csv')

write_csv(out.file, out.file.name)

message('\nFINISHED! output written to ',out.file.name)
