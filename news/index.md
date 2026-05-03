# Changelog

## version 0.2-16

- remove ‘%\>%’; depend on R 4.1.0

- [`st_snap_to_grid()`](https://r-spatial.github.io/lwgeom/reference/st_snap_to_grid.md)
  handles empty geometries;
  [\#100](https://github.com/r-spatial/lwgeom/issues/100)

## version 0.2-15

CRAN release: 2026-01-12

- [`st_geod_azimuth()`](https://r-spatial.github.io/lwgeom/reference/st_geod_azimuth.md)
  adds feature/pairwise azimuth
  [\#97](https://github.com/r-spatial/lwgeom/issues/97) by
  [@robitalec](https://github.com/robitalec)

- add
  [`st_geom_from_geohash()`](https://r-spatial.github.io/lwgeom/reference/st_geohash.md);
  [\#37](https://github.com/r-spatial/lwgeom/issues/37)

- fix default for argument `digits` in
  [`st_astext()`](https://r-spatial.github.io/lwgeom/reference/st_astext.md)

## version 0.2-14

CRAN release: 2024-02-21

- [`st_perimeter()`](https://r-spatial.github.io/lwgeom/reference/perimeter-deprecated.md)
  is deprecated in favor of
  [`st_perimeter_lwgeom()`](https://r-spatial.github.io/lwgeom/reference/perimeter.md),
  as `sf` takes over with
  [`sf::st_perimeter()`](https://r-spatial.github.io/sf/reference/geos_measures.html).

## version 0.2-13

CRAN release: 2023-05-22

## version 0.2-11

CRAN release: 2023-01-14

- replace [`sprintf()`](https://rdrr.io/r/base/sprintf.html) instances
  with `snprintf()`

## version 0.2-10

CRAN release: 2022-11-19

- fix -Wstrict-prototypes warnings

## version 0.2-9

CRAN release: 2022-10-01

- fix formatting issues for long long int

## version 0.2-8

CRAN release: 2021-10-06

- remove PROBLEM … ERROR constructs from C code

## version 0.2-5

CRAN release: 2020-06-12

- GEOS requirement lowered to 3.5.0, which also seems to work;
  [\#59](https://github.com/r-spatial/lwgeom/issues/59).

## version 0.2-4

CRAN release: 2020-05-20

- require sf \>= 0.9-3, and use C API PROJ path setting (to work on CRAN
  windows binaries)

- update to new GEOS (3.8.0) and PROJ (6.3.1) versions for CRAN windows
  binary builds

- require GEOS 3.6.0 (required by PostGIS 3.0.0), and add check to
  configure

## version 0.2-3

CRAN release: 2020-04-12

- fix configure script to work with ubuntu/bionic and PROJ 4.9.3;
  [\#28](https://github.com/r-spatial/lwgeom/issues/28)

- fix configure script to work with PROJ 5.x versions

## version 0.2-2

CRAN release: 2020-04-11

- adjust to sf \>= 0.9-0 new crs representation

- use
  [`st_make_valid()`](https://r-spatial.github.io/sf/reference/valid.html)
  generic from package sf; <https://github.com/r-spatial/sf/issues/1300>

## version 0.2-1

CRAN release: 2020-01-31

- fix PROJ 5.x installation issue (has proj.h, but shouldn’t use it)

## version 0.2-0

CRAN release: 2020-01-31

- export
  [`lwgeom_make_valid()`](https://r-spatial.github.io/lwgeom/reference/lwgeom_make_valid.md),
  to gradually move
  [`st_make_valid()`](https://r-spatial.github.io/sf/reference/valid.html)
  from `lwgeom` to `sf`; <https://github.com/r-spatial/sf/issues/989>

- constrain argument `crs` in
  [`st_transform_proj()`](https://r-spatial.github.io/lwgeom/reference/st_transform_proj.md)
  to take one or two character strings

- update to POSTGIS 3.0.0 liblwgeom version

- update to modern PROJ, use proj.h when available

## version 0.1-5

CRAN release: 2018-12-07

- check for user interrupts on
  [`st_geod_distance()`](https://r-spatial.github.io/lwgeom/reference/geod.md),
  [\#29](https://github.com/r-spatial/lwgeom/issues/29) by Dan Baston

- add
  [`st_astext()`](https://r-spatial.github.io/lwgeom/reference/st_astext.md)
  for fast WKT writing,
  [\#25](https://github.com/r-spatial/lwgeom/issues/25) by Etienne
  Racine

- add
  [`st_is_polygon_cw()`](https://r-spatial.github.io/lwgeom/reference/st_is_polygon_cw.md),
  [\#21](https://github.com/r-spatial/lwgeom/issues/21) by Andy Teucher
  [@ateucher](https://github.com/ateucher); add Andy Teucher to
  contributors

- add
  [`st_perimeter()`](https://r-spatial.github.io/lwgeom/reference/perimeter-deprecated.md)
  and
  [`st_perimeter_2d()`](https://r-spatial.github.io/lwgeom/reference/perimeter.md)
  functions to compute the length measurement of the boundary of a
  surface.

- allow
  [`st_transform_proj()`](https://r-spatial.github.io/lwgeom/reference/st_transform_proj.md)
  to take two proj4 strings as crs, as `c(input_p4s, output_p4s)`,
  ignoring the CRS of x

## version 0.1-4

CRAN release: 2018-01-28

- tries to fix the CRAN error for r-release-osx (datum files missing in
  sf; removed test)

## version 0.1-3

CRAN release: 2018-01-21

- add
  [`st_geod_covered_by()`](https://r-spatial.github.io/lwgeom/reference/geod.md)
  binary geometry predicate

## version 0.1-2

CRAN release: 2017-12-19

- try to fix OSX compile on CRAN, tuning configure.ac

## version 0.1-1

CRAN release: 2017-12-17

- add
  [`st_length()`](https://r-spatial.github.io/sf/reference/geos_measures.html)

- attempt to fix Solaris and OSX

- report proj.4 and GEOS versions on startup, and on
  `lwgeom_extSoftwareVersions`;
  [\#10](https://github.com/r-spatial/lwgeom/issues/10)

- add minimum bounding circle, by [@rundel](https://github.com/rundel);
  [\#7](https://github.com/r-spatial/lwgeom/issues/7)

- add
  [`st_subdivide()`](https://r-spatial.github.io/lwgeom/reference/st_subdivide.md),
  see <https://github.com/r-spatial/sf/issues/597>

## version 0.1-0

CRAN release: 2017-11-16

- first CRAN submission
