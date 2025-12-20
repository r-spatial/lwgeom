# Return a collection of geometries resulting by splitting a geometry

Return a collection of geometries resulting by splitting a geometry

## Usage

``` r
st_split(x, y)
```

## Arguments

- x:

  object with geometries to be splitted

- y:

  object split with (blade); if `y` contains more than one feature
  geometry, the geometries are
  [st_combine](https://r-spatial.github.io/sf/reference/geos_combine.html)
  'd

## Value

object of the same class as `x`

## Examples

``` r
library(sf)
l = st_as_sfc('MULTILINESTRING((10 10, 190 190), (15 15, 30 30, 100 90))')
pt = st_sfc(st_point(c(30,30)))
st_split(l, pt)
#> Geometry set for 1 feature 
#> Geometry type: GEOMETRYCOLLECTION
#> Dimension:     XY
#> Bounding box:  xmin: 10 ymin: 10 xmax: 190 ymax: 190
#> CRS:           NA
#> GEOMETRYCOLLECTION (LINESTRING (10 10, 30 30), ...
```
