FROM rocker/r-ver:4.0.4

# DeGAUSS container metadata
ENV degauss_name="drivetime"
ENV degauss_version="1.0"
ENV degauss_description="distance and drive time to care sites"
ENV degauss_argument="care_site [default: none]"

# add OCI labels based on environment variables too
LABEL "org.degauss.name"="${degauss_name}"
LABEL "org.degauss.version"="${degauss_version}"
LABEL "org.degauss.description"="${degauss_description}"
LABEL "org.degauss.argument"="${degauss_argument}"

# install required version of renv
RUN R --quiet -e "install.packages('remotes', repos = 'https://cran.rstudio.com')"
# make sure version matches what is used in the project: packageVersion('renv')
ENV RENV_VERSION 0.14.0
RUN R --quiet -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

WORKDIR /app

RUN apt-get update \
  && apt-get install -yqq --no-install-recommends \
  libgdal-dev \
  libgeos-dev \
  libudunits2-dev \
  libproj-dev \
  libv8-dev \
  && apt-get clean

COPY renv.lock .
RUN R --quiet -e "renv::restore(repos = c(CRAN = 'https://packagemanager.rstudio.com/all/__linux__/focal/latest'))"

COPY drivetime.R .
COPY isochrones_no_overlap.rds .
COPY center_addresses.csv .

WORKDIR /tmp

ENTRYPOINT ["/app/drivetime.R"]
