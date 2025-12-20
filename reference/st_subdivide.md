# Return a collection of geometries resulting by subdividing a geometry

Return a collection of geometries resulting by subdividing a geometry

## Usage

``` r
st_subdivide(x, max_vertices)
```

## Arguments

- x:

  object with geometries to be subdivided

- max_vertices:

  integer; maximum size of the subgeometries (at least 8)

## Value

object of the same class as `x`

## Examples

``` r
library(sf)
demo(nc, ask = FALSE, echo = FALSE)
x = st_subdivide(nc, 10)
plot(x[1])
```
