# Force a POLYGON or MULTIPOLYGON to be clockwise

Check if a POLYGON or MULTIPOLYGON is clockwise, and if not make it so.
According to the 'Right-hand-rule', outer rings should be clockwise, and
inner holes should be counter-clockwise

## Usage

``` r
st_force_polygon_cw(x)
```

## Arguments

- x:

  object with polygon geometries

## Value

object of the same class as `x`

## Examples

``` r
library(sf)
polys <- st_sf(cw = c(FALSE, TRUE), 
               st_as_sfc(c('POLYGON ((0 0, 1 0, 1 1, 0 0))', 
                           'POLYGON ((1 1, 2 2, 2 1, 1 1))')))

st_force_polygon_cw(polys)
#> Simple feature collection with 2 features and 1 field
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 0 ymin: 0 xmax: 2 ymax: 2
#> CRS:           NA
#>      cw
#> 1 FALSE
#> 2  TRUE
#>   st_as_sfc.c..POLYGON...0.0..1.0..1.1..0.0......POLYGON...1.1..2.2..2.1..1.1.....
#> 1                                                   POLYGON ((0 0, 1 1, 1 0, 0 0))
#> 2                                                   POLYGON ((1 1, 2 2, 2 1, 1 1))
st_force_polygon_cw(st_geometry(polys))
#> Geometry set for 2 features 
#> Geometry type: POLYGON
#> Dimension:     XY
#> Bounding box:  xmin: 0 ymin: 0 xmax: 2 ymax: 2
#> CRS:           NA
#> POLYGON ((0 0, 1 1, 1 0, 0 0))
#> POLYGON ((1 1, 2 2, 2 1, 1 1))
st_force_polygon_cw(st_geometry(polys)[[1]])
#> POLYGON ((0 0, 1 1, 1 0, 0 0))
```
