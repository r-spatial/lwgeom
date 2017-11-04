# lwgeom
bindings to the liblwgeom library

[![Build Status](https://travis-ci.org/r-spatial/lwgeom.png?branch=master)](https://travis-ci.org/r-spatial/lwgeom)
[![CRAN](http://www.r-pkg.org/badges/version/lwgeom)](https://cran.r-project.org/package=lwgeom)


(This does not include `liblwgeom`; it will need to be installed separately for functions that require it, such as `st_make_valid`, to work.)


### MacOS

According to https://github.com/r-spatial/sf/issues/349, `brew install postgis` installs a working `liblwgeom`. In case of problems, search the issues for `brew` before opening a new one.

### Linux

```sh
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get update
sudo apt-get install libgdal-dev libgeos-dev libproj-dev libudunits2-dev liblwgeom-dev
```
