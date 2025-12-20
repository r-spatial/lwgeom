# Generate the minimum bounding circle

Generate the minimum bounding circle

## Usage

``` r
st_minimum_bounding_circle(x, nQuadSegs = 30)
```

## Arguments

- x:

  object of class `sfg`, `sfg` or `sf`

- nQuadSegs:

  number of segments per quadrant (passed to `st_buffer`)

## Value

Object of the same class as `x`

## Details

`st_minimum_bounding_circle` uses the `lwgeom_calculate_mbc` method also
used by the PostGIS command `ST_MinimumBoundingCircle`.

## Examples

``` r
library(sf)
#> Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.4.0; sf_use_s2() is TRUE
#> 
#> Attaching package: ‘sf’
#> The following objects are masked from ‘package:lwgeom’:
#> 
#>     st_minimum_bounding_circle, st_perimeter

x = st_multipoint(matrix(c(0,1,0,1),2,2))
y = st_multipoint(matrix(c(0,0,1,0,1,1),3,2))

mbcx = st_minimum_bounding_circle(x)
mbcy = st_minimum_bounding_circle(y)

if (.Platform$OS.type != "windows") {
  plot(mbcx, axes=TRUE); plot(x, add=TRUE)
  plot(mbcy, axes=TRUE); plot(y, add=TRUE)
}



nc = st_read(system.file("gpkg/nc.gpkg", package="sf"))
#> Reading layer `nc.gpkg' from data source 
#>   `/home/runner/work/_temp/Library/sf/gpkg/nc.gpkg' using driver `GPKG'
#> Simple feature collection with 100 features and 14 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> Geodetic CRS:  NAD27
state = st_union(st_geometry(nc))

if (.Platform$OS.type != "windows") {
  plot(st_minimum_bounding_circle(state), asp=1)
  plot(state, add=TRUE)
}
#> Warning: st_minimum_rotated_rectangle does not work correctly for longitude/latitude data

```
