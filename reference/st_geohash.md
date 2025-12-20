# compute geohash from (average) coordinates

compute geohash from (average) coordinates

## Usage

``` r
st_geohash(x, precision = 0)

st_geom_from_geohash(
  hash,
  precision = -1,
  crs = st_crs("OGC:CRS84"),
  raw = FALSE
)
```

## Arguments

- x:

  object of class `sf`, `sfc` or `sfg`

- precision:

  integer; precision (length) of geohash returned. From the liblwgeom
  source: “where the precision is non-positive, a precision based on the
  bounds of the feature. Big features have loose precision. Small
  features have tight precision.”

- hash:

  character vector with geohashes

- crs:

  object of class \`crs\`

- raw:

  logical; if \`TRUE\`, return a matrix with bounding box coordinates on
  each row

## Value

\`st_geohash\` returns a character vector with geohashes; empty or full
geometries result in \`NA\`

\`st_geom_from_geohash\` returns a (bounding box) polygon for each
geohash if \`raw\` is \`FALSE\`, if \`raw\` is \`TRUE\` a matrix is
returned with bounding box coordinates on each row.

## Details

see <https://en.wikipedia.org/wiki/Geohash>.

## Examples

``` r
library(sf)
lwgeom::st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 2)
#> [1] "s0" "up"
lwgeom::st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 10)
#> [1] "s095fjhkbx" "upbpbpbpbp"
st_geom_from_geohash(c('9qqj7nmxncgyy4d0dbxqz0', 'up'), raw = TRUE)
#>           xmin     ymin      xmax     ymax
#> [1,] -115.1728 36.11465 -115.1728 36.11465
#> [2,]    0.0000 84.37500   11.2500 90.00000
o = options(digits = 20) # for printing purposes
st_geom_from_geohash(c('9qqj7nmxncgyy4d0dbxqz0', 'u1hzz631zyd63zwsd7zt'))
#> Geometry set for 2 features 
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -115.172816 ymin: 36.114646 xmax: 7.00000000000014 ymax: 52.0000000000001
#> Geodetic CRS:  WGS 84 (CRS84)
#> POLYGON ((-115.17281600000001163 36.11464599999...
#> POLYGON ((6.9999999999998152589 51.999999999999...
st_geom_from_geohash('9qqj7nmxncgyy4d0dbxqz0', 4) 
#> Geometry set for 1 feature 
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -115.3125 ymin: 36.03515625 xmax: -114.9609375 ymax: 36.2109375
#> Geodetic CRS:  WGS 84 (CRS84)
#> POLYGON ((-115.3125 36.03515625, -114.9609375 3...
st_geom_from_geohash('9qqj7nmxncgyy4d0dbxqz0', 10)
#> Geometry set for 1 feature 
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -115.17282128334 ymin: 36.1146408319473 xmax: -115.172810554504 ymax: 36.1146461963654
#> Geodetic CRS:  WGS 84 (CRS84)
#> POLYGON ((-115.1728212833404541 36.114640831947...
options(o)
```
