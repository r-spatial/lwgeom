# lwgeom

R bindings to the
[liblwgeom](https://github.com/postgis/postgis/tree/master/liblwgeom)
library

This package provides functions that use `liblwgeom`, including
[`st_geohash()`](https://r-spatial.github.io/lwgeom/reference/st_geohash.md),
[`st_minimum_bounding_circle()`](https://r-spatial.github.io/lwgeom/reference/bounding_circle.md),
[`st_split()`](https://r-spatial.github.io/lwgeom/reference/st_split.md),
[`st_subdivide()`](https://r-spatial.github.io/lwgeom/reference/st_subdivide.md),
[`st_transform_proj()`](https://r-spatial.github.io/lwgeom/reference/st_transform_proj.md)
(transform through proj, omitting GDAL) and
[`st_as_sfc.TWKB()`](https://r-spatial.github.io/lwgeom/reference/st_as_sfc.TWKB.md)
(creates `sfc` from [tiny
wkb](https://github.com/TWKB/Specification/blob/master/twkb.md)), as
well as the geodetic (spherical/ellipsoidal) geometry functions
[`st_geod_area()`](https://r-spatial.github.io/lwgeom/reference/geod.md),
[`st_geod_length()`](https://r-spatial.github.io/lwgeom/reference/geod.md),
[`st_geod_distance()`](https://r-spatial.github.io/lwgeom/reference/geod.md),
[`st_geod_covers()`](https://r-spatial.github.io/lwgeom/reference/geod.md),
[`st_geod_azimuth()`](https://r-spatial.github.io/lwgeom/reference/st_geod_azimuth.md),
and
[`st_geod_segmentize()`](https://r-spatial.github.io/lwgeom/reference/geod.md).
The previously offered `st_make_valid()` is now a generic in package
`sf`
([`sf::st_make_valid()`](https://r-spatial.github.io/sf/reference/valid.html)).

## Installing

`lwgeom` depends on [sf](https://github.com/r-spatial/sf), which has to
be installed first. This package uses the liblwgeom library, and
compiles a shipped (and modified) version of liblwgeom. It links to the
GEOS and PROJ libraries.

To install from source, it should be enough to have installed `sf` from
source; the resources for this package (PROJ, GEOS) are being reused.

## lwgeom source now included

Previous to version 0.1-6, `lwgeom` would also try to link the system
library liblwgeom; from 0.1-6 on only the shipped version is used.

## Contributing

- Contributions of all sorts are most welcome, issues and pull requests
  are the preferred ways of sharing them.
- When contributing pull requests, please adhere to the package style
  (in package code use `=` rather than `<-`; don’t change indentation;
  tab stops of 4 spaces are preferred)
- This project is released with a [Contributor Code of
  Conduct](https://r-spatial.github.io/lwgeom/CONDUCT.md). By
  participating in this project you agree to abide by its terms.
