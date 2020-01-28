suppressPackageStartupMessages(library(sf))
library(sp)
suppressPackageStartupMessages(library(units))
library(geosphere)

x = st_sfc(
st_point(c(0,0)),
st_point(c(1,0)),
st_point(c(2,0)),
st_point(c(3,0)),
crs = 4326
)

y = st_sfc(
st_point(c(0,10)),
st_point(c(1,0)),
st_point(c(2,0)),
st_point(c(3,0)),
st_point(c(4,0)),
crs = 4326
)

st_crs(y) = 4326
st_crs(x) = 4326
(d.sf = st_distance(x, y))
