# drivetime <a href='https://degauss.org'><img src='https://github.com/degauss-org/degauss_hex_logo/raw/main/PNG/degauss_hex.png' align='right' height='138.5' /></a>

[![](https://img.shields.io/github/v/release/degauss-org/drivetime?color=469FC2&label=version&sort=semver)](https://github.com/degauss-org/drivetime/releases)
[![container build status](https://github.com/degauss-org/drivetime/workflows/build-deploy-release/badge.svg)](https://github.com/degauss-org/drivetime/actions/workflows/build-deploy-release.yaml)

## Using

If `my_address_file_geocoded.csv` is a file in the current working directory with coordinate columns named `lat` and `lon`, then the [DeGAUSS command](https://degauss.org/using_degauss.html#DeGAUSS_Commands):

```sh
docker run --rm -v $PWD:/tmp ghcr.io/degauss-org/drivetime:1.3.0 my_address_file_geocoded.csv cchmc
```

will produce `my_address_file_geocoded_drivetime_1.3.0_cchmc.csv` with added columns:

- **`drive_time`**: drive time in minutes (6-minute intervals; "> 60" if more than 1 hour drive time)
- **`distance`**: distance in meters

### Required Argument

This DeGAUSS container requires an argument to specify care center. The example above uses `cchmc` for Cincinnati Children's Hospital Medical Center. To change the care center, replace `cchmc` with one of the site abbrevations below. 

| **Name** |  **Abbreviation** |
|--------------------|-------------------|
Children's Children's Hospital Medical Center - Main Campus | `cchmc` 
Children's Children's Hospital Medical Center - Liberty Campus | `liberty` 
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
Nationwide Children's Hospital | `nat`
University of California, Los Angeles | `ucla`
Boston Children's Hospital | `bch`
Medical College of Wisconsin | `mcw`
St. Jude's Children's Hospital | `stj`
Martha Eliot Health Center | `mehc`
Ann & Lurie Children's / Northwestern | `nwu`
Lurie Children's Center in Northbrook | `lccn`
Lurie Children's Center in Lincoln Park | `lcclp`
Lurie Children's Center in Uptown | `lccu`
Dr. Lio's and Dr. Aggarwal's Clinics | `lac`
Recruited from Eczema Expo 2018 | `expo`
University of California San Francisco Benioff Children's Hospital | `ucsf`
Nicklaus Children's Hospital |	`nicklaus`
Medical University of South Carolina Children's Hospital	| `musc`
Children's National Medical Center	| `cnmc`
Children's Hospital of Pittsburgh of UPMC	| `upmc`
Methodist LeBonheur Children's Hospital	| `methodist`
Texas Children's Hospital	| `texas`
Arkansas Children's Hospital	| `arkansas`
Primary Children's Medical Center	| `primary`
Children's Healthcare of Atlanta	| `atlanta`
Children's Medical Center of Dallas	| `dallas`
Lucile Packard Children's Hospital Stanford	| `packard`
Toronto Hospital for Sick Children	| `toronto`
Cook Children's Medical Center	| `cook`
Children's Hospital & Medical Center - Omaha	| `omaha`
Children's Hospital Colorado	| `colorado`
Arnold Palmer Hospital for Children	| `palmer`
Children's Hospital & Clinics of Minnesota	| `minn`
University of Virginia Hospital	| `uva`
Joe Dimaggio Children's Hospital	| `dimaggio`
Cohen Children's Medical Center of New York at Northwell Health	| `cohen`
Dell Children's Medical Center of Central Texas	| `dell`
A.I. duPont Hospital for Children	| `dupont`
Rainbow Babies and Children's Hospital	| `rainbow`
UNC Hospitals Children's Specialty Clinic	| `unc`
Barbara Bush Children's Hospital at Maine Medical	| `maine`
Children's Hospital of New Orleans | `chnola`
Rady Children's Hospital | `rady`
Children's Hospital Los Angeles |	`chla`
Monroe Carell Jr. Children's Hospital at Vanderbilt |	`vandy`

## Geomarker Methods

**drive time**

This container uses isochrones to assign drive time to care center for each input address. Drive time isochrones are concentric polygons, in which each point inside a polygon has the same drive time to the care center. Below is an example of drive time isochrones around Cincinnati Children's Hospital Medical Center.

![](figs/cchmc_isochrones_fig.png)

Drive time isochrones were obtained from [openroute service](https://maps.openrouteservice.org/reach?n1=38.393339&n2=-95.339355&n3=5&b=0&i=0&j1=30&j2=15&k1=en-US&k2=km).

**distance**

Euclidean distance between input address and care center in meters. This distance does not take into account driving routes, but rather provides an overall metric for how far a participant lives from their care center.

## Geomarker Data

- `download_isochrones.R` was used to download and prepare drive time isochrones
- Isochrone shape files are stored at [`s3://geomarker/drivetime/isochrones/`](https://geomarker.s3-us-east-2.amazonaws.com/drivetime/isochrones)
- A list of available care center addresses is also stored at [`s3://geomarker/drivetime/center_addresses.csv`](https://geomarker.s3-us-east-2.amazonaws.com/drivetime/center_addresses.csv)

## DeGAUSS Details

For detailed documentation on DeGAUSS, including general usage and installation, please see the [DeGAUSS homepage](https://degauss.org).