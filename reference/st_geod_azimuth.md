# compute azimuth between sequence of points

compute azimuth between sequence of points

## Usage

``` r
st_geod_azimuth(x, y = NULL)
```

## Arguments

- x:

  object of class `sf`, `sfc` or `sfg`

- y:

  object of class `sf`, `sfc` or `sfg`, or NULL

## Examples

``` r
library(sf)
p = st_sfc(st_point(c(7,52)), st_point(c(8,53)), crs = 4326)
st_geod_azimuth(p)
#> 0.5410385 [rad]
```
