# lwgeom
bindings to the liblwgeom library

[![Build Status](https://travis-ci.org/r-spatial/lwgeom.png?branch=master)](https://travis-ci.org/r-spatial/lwgeom)
[![CRAN](http://www.r-pkg.org/badges/version/lwgeom)](https://cran.r-project.org/package=lwgeom)


This package provides a few functions that require `liblwgeom`, including 
`st_geohash`,
`st_make_valid`, 
`st_minimum_bounding_circle`,
`st_split`, and
`st_transform_proj`.

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
