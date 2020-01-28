suppressPackageStartupMessages(library(lwgeom))
suppressPackageStartupMessages(library(sf))
nc = read_sf(system.file("gpkg/nc.gpkg", package="sf"), quiet = TRUE)
nc = st_transform(nc, 3857)
st_perimeter(nc)[1:5]
st_perimeter_2d(nc)[1:5]
