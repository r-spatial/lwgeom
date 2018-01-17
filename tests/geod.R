### Name: lw_geodetic
### Title: geodetic length, area, and predicates
### Aliases: lw_geodetic st_geod_area lw_geodetic st_geod_length
###   lw_geodetic st_geod_segmentize lw_geodetic st_geod_covers

### ** Examples

suppressPackageStartupMessages(library(sf))
suppressPackageStartupMessages(library(lwgeom))
suppressPackageStartupMessages(library(units))
nc = st_read(system.file("gpkg/nc.gpkg", package="sf"), quiet = TRUE)
st_geod_area(nc[1:3,])
# st_area(nc[1:3,])
l = st_sfc(st_linestring(rbind(c(7,52), c(8,53))), crs = 4326)
st_geod_length(l)
pol = st_polygon(list(rbind(c(0,0), c(0,60), c(60,60), c(0,0))))
x = st_sfc(pol, crs = 4326)
seg = st_geod_segmentize(x[1], set_units(10, km))
plot(seg, graticule = TRUE, axes = TRUE)
pole = st_polygon(list(rbind(c(0,80), c(120,80), c(240,80), c(0,80))))
pt = st_point(c(0,90))
x = st_sfc(pole, pt, crs = 4326)
st_geod_covers(x[c(1,1,1)], x[c(2,2,2,2)])
st_geod_covered_by(x[c(2,2)], x[c(1,1,1)])
st_geod_covers(x[c(1,1,1)], x[c(2,2,2,2)], sparse = FALSE)
st_geod_covered_by(x[c(2,2)], x[c(1,1,1)], sparse = FALSE)

# box crossing the dateline:
#box = st_polygon(list(rbind(c(179.5,0), c(179.5,1), c(-179.5,1), c(-179.5,0), c(179.5,0))))
box = st_polygon(list(rbind(c(179.5,0.1), c(179.5,1), c(-179.5,1), c(-179.5,0.1), c(179.5,0.1))))
b = st_sfc(box, crs = 4326)
units::set_units(st_geod_area(b), km^2) # approx 111^2

pt = st_point(c(30, 70))
x = st_sfc(pole, pt, pt, crs = 4326)
st_geod_distance(x, x)
st_geod_distance(x, x, sparse = TRUE)
st_geod_distance(x, x, tolerance = 1, sparse = TRUE)
