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
d.sf = st_distance(x, y)
d.sp = spDists(as(x, "Spatial"), as(y, "Spatial")) # equiv to geosphere::distMeeus
d.sf - set_units(d.sp, km)

# compare to geosphere::distVincentyEllispoid:
dv = matrix(NA_real_, 4, 5)
dv[1,] = distVincentyEllipsoid(as(x, "Spatial")[1], as(y, "Spatial"))
dv[2,] = distVincentyEllipsoid(as(x, "Spatial")[2], as(y, "Spatial"))
dv[3,] = distVincentyEllipsoid(as(x, "Spatial")[3], as(y, "Spatial"))
dv[4,] = distVincentyEllipsoid(as(x, "Spatial")[4], as(y, "Spatial"))
d.sf - set_units(dv, m) # difference in micrometer range:
