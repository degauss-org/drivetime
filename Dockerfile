FROM rocker/geospatial:3.5.3

LABEL maintainer="Cole Brokamp <cole.brokamp@gmail.com>"

RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), prompt='R > ', download.file.method = 'libcurl')" > /.Rprofile

RUN R -e "devtools::install_version(package = 'sf', version = '0.7-3', upgrade = FALSE, quiet = TRUE)"
RUN R -e "devtools::install_version(package = 'argparser', version = '0.4', upgrade = FALSE, quiet = TRUE)"
RUN R -e "devtools::install_version(package = 'dplyr', version = '0.8.0.1', upgrade = FALSE, quiet = TRUE)"
RUN R -e "devtools::install_version(package = 'readr', version = '1.3.1', upgrade = FALSE, quiet = TRUE)"

RUN R -e "library(sf); library(argparser); library(dplyr); library(readr)"

RUN mkdir /app
COPY . /app

WORKDIR /tmp

ENTRYPOINT ["/app/_pepr_drivetime_isochrones.R"]
