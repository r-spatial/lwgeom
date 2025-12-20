# Return Well-known Text representation of simple feature geometry

Return Well-known Text representation of simple feature geometry or
coordinate reference system

## Usage

``` r
st_astext(x, digits = getOption("digits"), ..., EWKT = FALSE)

st_asewkt(x, digits = options("digits"))
```

## Arguments

- x:

  object of class `sfg`, `sfc`, or `sf`

- digits:

  integer; number of decimal digits to print

- ...:

  ignored

- EWKT:

  logical; use PostGIS Enhanced WKT (includes srid)

## Details

The returned WKT representation of simple feature geometry conforms to
the [simple features access](https://www.ogc.org/standards/sfa/)
specification and extensions (if `EWKT = TRUE`), [known as
EWKT](http://postgis.net/docs/using_postgis_dbmanagement.html#EWKB_EWKT),
supported by PostGIS and other simple features implementations for
addition of SRID to a WKT string.

`st_asewkt()` returns the Well-Known Text (WKT) representation of the
geometry with SRID meta data.

## Examples

``` r
library(sf)
pt <- st_sfc(st_point(c(1.0002,2.3030303)), crs = 4326)
st_astext(pt, 3)
#> [1] "POINT(1 2.303)"
st_asewkt(pt, 3)
#> [1] "SRID=4326;POINT(1 2.303)"
```
