suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(lwgeom))
p = st_sfc(st_point(c(7,52)), st_point(c(8,53)), crs = 4326)
st_geod_azimuth(p)
