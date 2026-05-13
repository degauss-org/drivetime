library(RColorBrewer)

isochrones_no_overlap <- readRDS("pepr_isochrones_no_overlap_5072.rds") # 5072 projection

site_name_list <- site_names[['cchmc']]
drivetime_minutes <- isochrones_no_overlap[[site_name_list]]

pal_isochrones <- viridis::viridis(n=10, direction = -1)

mapview::mapview(drivetime_minutes,
                 col.regions = pal_isochrones)
