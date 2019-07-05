# degauss/pepr_drivetime

> DeGAUSS container that calculates driving distance to care center for PEPR multi-site study

## Drive Time Isochrones

This container uses isochrones to assign drive time to care center for each participant address.  Drive time sochrones are concentric polygons, in which each point inside a polygon has the same drive time to the care center. Below is an example of drive time isochrones around Cincinnati Children's Hospital.

![](figs/cchmc_isochrones_fig.png)

For each care center, drive times are assigned in 6-minute intervals.  Any locations that are farther than 1 hour away will be assigned a drive time of ">60".

Drive time isochrones were obtained from [openroute service](https://maps.openrouteservice.org/reach?n1=38.393339&n2=-95.339355&n3=5&b=0&i=0&j1=30&j2=15&k1=en-US&k2=km).

## Distance 

This container also calculates "as the crow flies" distance (meters) from care center for each participant address. The distance does not take into account driving routes, but rather provides an overall metric for how far a participant lives from their care center.

## Using

DeGAUSS arguments specific to this container:

- `file_name`: name of a CSV file in the current working directory with columns named `lat` and `lon`
- `site`: abbreviation for care center for which you would like to obtain drive time and distance; must be from the list below

| **Name** |  **Abbreviation** |
|--------------------|-------------------|
Children's Hospital of Philadelphia | `chop` 
Riley Hospital for Children, Indiana University | `riley`
Seattle Children's Hospital | `seattle`
Children's Mercy Hospital | `mercy`
Emory University | `emory`
Johns Hopkins University | `jhu`
Cleveland Clinic | `cc`
Levine Children's | `levine`
St. Louis Children's Hospital | `stl`
Oregon Health and Science University | `ohsu`
University of Michigan Health System | `umich`
Children's Hospital of Alabama | `al`
Cincinnati Children's Hospital Medical Center | `cchmc`
Nationwide Children's Hospital | `nat`
University of California, Los Angeles | `ucla`

Example call:

`docker run --rm=TRUE -v $PWD:/tmp quay.io/degauss/pepr_drivetime geocoded_csv_file.csv cchmc`

In the above example call, replace `geocoded_csv_file.csv` with the name of your geocoded csv file and `cchmc` with the abbreviation for the care center to be used for drive time and distance calculations.

Some progress messages will be printed and when complete, the program will save the output as the same name as the input file name, but with `pepr_drivetime` and the care center abbreviation appended, e.g. `geocoded_csv_file_pepr_drivetime_cchmc.csv`

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS](https://github.com/cole-brokamp/DeGAUSS) README.

This software is part of DeGAUSS and uses its same [license](https://github.com/cole-brokamp/DeGAUSS/blob/master/LICENSE.txt).