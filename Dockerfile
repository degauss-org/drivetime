FROM rocker/r-ver:4.0.5

# DeGAUSS container metadata
ENV degauss_name="drivetime"
ENV degauss_version="1.3.1"
ENV degauss_description="distance and drive time to care sites"
ENV degauss_argument="care_site [default: none]"

# add OCI labels based on environment variables too
LABEL "org.degauss.name"="${degauss_name}"
LABEL "org.degauss.version"="${degauss_version}"
LABEL "org.degauss.description"="${degauss_description}"
LABEL "org.degauss.argument"="${degauss_argument}"

RUN R --quiet -e "install.packages('remotes', repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"

RUN R --quiet -e "remotes::install_github('rstudio/renv@0.15.4')"

WORKDIR /app

RUN apt-get update \
    && apt-get install -yqq --no-install-recommends \
    libgdal-dev \
    libgeos-dev \
    libudunits2-dev \
    libproj-dev \
    && apt-get clean

COPY renv.lock .

RUN R --quiet -e "renv::restore(repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"

ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/center_addresses.csv center_addresses.csv
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/al_isochrones.rds isochrones/al_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/arkansas_isochrones.rds isochrones/arkansas_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/atlanta_isochrones.rds isochrones/atlanta_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/bch_isochrones.rds isochrones/bch_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/cc_isochrones.rds isochrones/cc_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/cchmc_isochrones.rds isochrones/cchmc_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/chla_isochrones.rds isochrones/chla_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/chnola_isochrones.rds isochrones/chnola_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/chop_isochrones.rds isochrones/chop_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/cnmc_isochrones.rds isochrones/cnmc_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/cohen_isochrones.rds isochrones/cohen_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/colorado_isochrones.rds isochrones/colorado_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/cook_isochrones.rds isochrones/cook_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/dallas_isochrones.rds isochrones/dallas_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/dell_isochrones.rds isochrones/dell_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/dimaggio_isochrones.rds isochrones/dimaggio_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/dupont_isochrones.rds isochrones/dupont_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/emory_isochrones.rds isochrones/emory_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/expo_isochrones.rds isochrones/expo_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/jhu_isochrones.rds isochrones/jhu_isochrones.rds 
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/lac_isochrones.rds isochrones/lac_isochrones.rds 
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/lcclp_isochrones.rds isochrones/lcclp_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/lccu_isochrones.rds isochrones/lccu_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/levine_isochrones.rds isochrones/levine_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/liberty_isochrones.rds isochrones/liberty_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/maine_isochrones.rds isochrones/maine_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/mcw_isochrones.rds isochrones/mcw_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/mehc_isochrones.rds isochrones/mehc_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/mercy_isochrones.rds isochrones/mercy_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/methodist_isochrones.rds isochrones/methodist_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/minn_isochrones.rds isochrones/minn_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/musc_isochrones.rds isochrones/musc_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/nat_isochrones.rds isochrones/nat_isochrones.rds 
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/nicklaus_isochrones.rds isochrones/nicklaus_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/nwu_isochrones.rds isochrones/nwu_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/ohsu_isochrones.rds isochrones/ohsu_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/omaha_isochrones.rds isochrones/omaha_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/packard_isochrones.rds isochrones/packard_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/palmer_isochrones.rds isochrones/palmer_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/primary_isochrones.rds isochrones/primary_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/rady_isochrones.rds isochrones/rady_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/rainbow_isochrones.rds isochrones/rainbow_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/riley_isochrones.rds isochrones/riley_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/seattle_isochrones.rds isochrones/seattle_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/stj_isochrones.rds isochrones/stj_isochrones.rds 
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/stl_isochrones.rds isochrones/stl_isochrones.rds 
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/texas_isochrones.rds isochrones/texas_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/toronto_isochrones.rds isochrones/toronto_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/ucla_isochrones.rds isochrones/ucla_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/ucsf_isochrones.rds isochrones/ucsf_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/umich_isochrones.rds isochrones/umich_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/unc_isochrones.rds isochrones/unc_isochrones.rds 
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/upmc_isochrones.rds isochrones/upmc_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/uva_isochrones.rds isochrones/uva_isochrones.rds
ADD https://github.com/degauss-org/drivetime/releases/download/1.3.0/vandy_isochrones.rds isochrones/vandy_isochrones.rds
COPY entrypoint.R .

WORKDIR /tmp

ENTRYPOINT ["/app/entrypoint.R"]
