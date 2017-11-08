# lwgeom
R bindings to the liblwgeom library

[![Build Status](https://travis-ci.org/r-spatial/lwgeom.png?branch=master)](https://travis-ci.org/r-spatial/lwgeom)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/r-spatial/lwgeom?branch=master&svg=true)](https://ci.appveyor.com/project/edzer/lwgeom)
[![Coverage Status](https://img.shields.io/codecov/c/github/r-spatial/lwgeom/master.svg)](https://codecov.io/github/r-spatial/lwgeom?branch=master)
[![CRAN](http://www.r-pkg.org/badges/version/lwgeom)](https://cran.r-project.org/package=lwgeom)


This package provides a few functions that require
`liblwgeom`, including `st_geohash`, `st_make_valid`,
`st_minimum_bounding_circle`, `st_split`,
`st_transform_proj` (transform through proj, omitting
GDAL) and `st_as_sfc.TWKB` (create `sfc` from [tiny
wkb](https://github.com/TWKB/Specification/blob/master/twkb.md)),
as well as the geodetic (spherical/ellipsoidal) geometry
functions `st_geod_area`, `st_geod_azimuth`, `st_geod_covers`,
`st_geod_length`, and `st_geod_segmentize`.

## Installing

`lwgeom` depends on [sf](https://github.com/r-spatial/sf), which has to be installed first.

### MacOS

According to https://github.com/r-spatial/sf/issues/349, `brew
install postgis` installs a working `liblwgeom`. In case of problems,
search for `brew` in the [sf issues](https://github.com/sf/issues)
before opening a new one.

### Linux

On ubuntu, install the following:

```sh
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install libgdal-dev libgeos-dev libproj-dev libudunits2-dev liblwgeom-dev
```

### Windows

The `lwgeom` package on windows compiles the `liblwgeom` sources,
and uses the external dependencies (GEOS, PROJ) from the `gdal2`
[winlib](https://github.com/rwinlib/gdal2).
