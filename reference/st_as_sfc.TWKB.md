# create sfc object from tiny well-known binary (twkb)

create sfc object from tiny well-known binary (twkb)

## Usage

``` r
# S3 method for class 'TWKB'
st_as_sfc(x, ...)
```

## Arguments

- x:

  list with raw vectors, of class `TWKB`

- ...:

  ignored

## See also

https://github.com/TWKB/Specification/blob/master/twkb.md

## Examples

``` r
l = structure(list(as.raw(c(0x02, 0x00, 0x02, 0x02, 0x02, 0x08, 0x08))), class = "TWKB")
library(sf) # load generic
st_as_sfc(l)
#> Geometry set for 1 feature 
#> Geometry type: LINESTRING
#> Dimension:     XY
#> Bounding box:  xmin: 1 ymin: 1 xmax: 5 ymax: 5
#> CRS:           NA
#> LINESTRING (1 1, 5 5)
```
