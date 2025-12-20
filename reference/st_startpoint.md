# Return the start and end points from lines

Return the start and end points from lines

## Usage

``` r
st_startpoint(x)

st_endpoint(x)
```

## Arguments

- x:

  line of class `sf`, `sfc` or `sfg`

## Value

`sf` object representing start and end points

## Details

see <https://postgis.net/docs/ST_StartPoint.html> and
<https://postgis.net/docs/ST_EndPoint.html>.

## Examples

``` r
library(sf)
m = matrix(c(0, 1, 2, 0, 1, 4), ncol = 2)
l = st_sfc(st_linestring(m))
lwgeom::st_startpoint(l)
#> Geometry set for 1 feature 
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 0 ymin: 0 xmax: 0 ymax: 0
#> CRS:           NA
#> POINT (0 0)
lwgeom::st_endpoint(l)
#> Geometry set for 1 feature 
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 2 ymin: 4 xmax: 2 ymax: 4
#> CRS:           NA
#> POINT (2 4)
l2 = st_sfc(st_linestring(m), st_linestring(m[3:1, ]))
lwgeom::st_startpoint(l2)
#> Geometry set for 2 features 
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 0 ymin: 0 xmax: 2 ymax: 4
#> CRS:           NA
#> POINT (0 0)
#> POINT (2 4)
lwgeom::st_endpoint(l2)
#> Geometry set for 2 features 
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 0 ymin: 0 xmax: 2 ymax: 4
#> CRS:           NA
#> POINT (2 4)
#> POINT (0 0)
```
