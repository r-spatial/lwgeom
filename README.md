# lwgeom
R bindings to the [liblwgeom](https://github.com/postgis/postgis/tree/master/liblwgeom) library

<!-- badges: start -->
[![R-CMD-check](https://github.com/r-spatial/lwgeom/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-spatial/lwgeom/actions/workflows/R-CMD-check.yaml)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/r-spatial/lwgeom?branch=master&svg=true)](https://ci.appveyor.com/project/edzer/lwgeom)
[![Coverage Status](https://img.shields.io/codecov/c/github/r-spatial/lwgeom/master.svg)](https://app.codecov.io/github/r-spatial/lwgeom?branch=master)
[![CRAN](http://www.r-pkg.org/badges/version/lwgeom)](https://cran.r-project.org/package=lwgeom)
[![cran checks](https://badges.cranchecks.info/worst/lwgeom.svg)](https://cran.r-project.org/web/checks/check_results_lwgeom.html)
[![Downloads](http://cranlogs.r-pkg.org/badges/lwgeom?color=brightgreen)](https://www.r-pkg.org:443/pkg/lwgeom)
<!-- badges: end -->


This package provides functions that use
`liblwgeom`, including `st_geohash`,
`st_minimum_bounding_circle`, `st_split`, `st_subdivide`,
`st_transform_proj` (transform through proj, omitting
GDAL) and `st_as_sfc.TWKB` (creates `sfc` from [tiny
wkb](https://github.com/TWKB/Specification/blob/master/twkb.md)),
as well as the geodetic (spherical/ellipsoidal) geometry
functions `st_geod_area`, 
`st_geod_length`, 
`st_geod_distance`, 
`st_geod_covers`,
`st_geod_azimuth`, 
and `st_geod_segmentize`. The previously offered `st_make_valid`
is now a generic in package `sf`.

## Installing 

`lwgeom` depends on [sf](https://github.com/r-spatial/sf), which
has to be installed first.  This package uses the liblwgeom library,
and compiles a shipped (and modified) version of liblwgeom.  It links
to the GEOS and PROJ libraries. 

To install from source, it should be enough to have installed
`sf` from source; the resources for this package (PROJ, GEOS)
are being reused.

## lwgeom source now included 

Previous to version 0.1-6, `lwgeom` would also try to link the system
library liblwgeom; from 0.1-6 on only the shipped version is used.
