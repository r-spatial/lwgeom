# Check if a POLYGON or MULTIPOLYGON is clockwise

Check if a POLYGON or MULTIPOLYGON is clockwise. According to the
'Right-hand-rule', outer rings should be clockwise, and inner holes
should be counter-clockwise

## Usage

``` r
st_is_polygon_cw(x)
```

## Arguments

- x:

  object with polygon geometries

## Value

logical with length the same number of features in \`x\`

## Examples

``` r
library(sf)
polys <- st_sf(cw = c(FALSE, TRUE), 
               st_as_sfc(c('POLYGON ((0 0, 1 0, 1 1, 0 0))', 
                           'POLYGON ((1 1, 2 2, 2 1, 1 1))')))

st_is_polygon_cw(polys)
#> [1] FALSE  TRUE
st_is_polygon_cw(st_geometry(polys))
#> [1] FALSE  TRUE
st_is_polygon_cw(st_geometry(polys)[[1]])
#> [1] FALSE
```
