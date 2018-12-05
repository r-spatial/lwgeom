# version 0.1-5

* check for user interrupts on `st_geod_distance`, #29 by Dan Baston

* add `st_astext` for fast WKT writing, #25 by Etienne Racine

* add `st_is_polygon_cw`, #21 by Andy Teucher @ateucher; add Andy Teucher to contributors

* add `st_perimeter` and `st_perimeter_2d` functions to compute the length measurement of the boundary of a surface.

* allow `st_transform_proj` to take two proj4 strings as crs, as `c(input_p4s, output_p4s)`, ignoring the CRS of x

# version 0.1-4

* tries to fix the CRAN error for r-release-osx (datum files missing in sf; removed test)

# version 0.1-3

* add `st_geod_covered_by` binary geometry predicate

# version 0.1-2

* try to fix OSX compile on CRAN, tuning configure.ac

# version 0.1-1

* add `st_length`

* attempt to fix Solaris and OSX

* report proj.4 and GEOS versions on startup, and on `lwgeom_extSoftwareVersions`; #10

* add minimum bounding circle, by @rundel; #7

* add `st_subdivide`, see https://github.com/r-spatial/sf/issues/597

# version 0.1-0

* first CRAN submission
