# Transform or convert coordinates of simple features directly with Proj.4 (bypassing GDAL)

Transform or convert coordinates of simple features directly with Proj.4
(bypassing GDAL)

## Usage

``` r
st_transform_proj(x, crs, ...)

# S3 method for class 'sfc'
st_transform_proj(x, crs, ...)

# S3 method for class 'sf'
st_transform_proj(x, crs, ...)

# S3 method for class 'sfg'
st_transform_proj(x, crs, ...)
```

## Arguments

- x:

  object of class sf, sfc or sfg

- crs:

  character; target CRS, or, in case of a length 2 character vector,
  source and target CRS

- ...:

  ignored

## Details

Transforms coordinates of object to new projection, using PROJ directly
rather than the GDAL API used by
[st_transform](https://r-spatial.github.io/sf/reference/st_transform.html).

If `crs` is a single CRS, it forms the target CRS, and in that case the
source CRS is obtained as `st_crs(x)`. Since this presumes that the
source CRS is accepted by GDAL (which is not always the case), a second
option is to specify the source and target CRS as two proj4strings in
argument `crs`. In the latter case, `st_crs(x)` is ignored and may well
be `NA`.

The `st_transform_proj` method for `sfg` objects assumes that the CRS of
the object is available as an attribute of that name.

## Examples

``` r
library(sf)
p1 = st_point(c(7,52))
p2 = st_point(c(-30,20))
sfc = st_sfc(p1, p2, crs = 4326)
sfc
#> Geometry set for 2 features 
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -30 ymin: 20 xmax: 7 ymax: 52
#> Geodetic CRS:  WGS 84
#> POINT (7 52)
#> POINT (-30 20)
st_transform_proj(sfc, "+proj=wintri")
#> Geometry set for 2 features 
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: -3270597 ymin: 2238779 xmax: 665843 ymax: 5789966
#> Projected CRS: +proj=wintri
#> POINT (665843 5789966)
#> POINT (-3270597 2238779)
library(sf)
nc = st_read(system.file("shape/nc.shp", package="sf"))
#> Reading layer `nc' from data source 
#>   `/home/runner/work/_temp/Library/sf/shape/nc.shp' using driver `ESRI Shapefile'
#> Simple feature collection with 100 features and 14 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -84.32385 ymin: 33.88199 xmax: -75.45698 ymax: 36.58965
#> Geodetic CRS:  NAD27
st_transform_proj(nc[1,], "+proj=wintri +over")
#> Simple feature collection with 1 feature and 14 fields
#> Geometry type: MULTIPOLYGON
#> Dimension:     XY
#> Bounding box:  xmin: -6776742 ymin: 4191789 xmax: -6736178 ymax: 4233236
#> Projected CRS: +proj=wintri +over
#>    AREA PERIMETER CNTY_ CNTY_ID NAME  FIPS FIPSNO CRESS_ID BIR74 SID74 NWBIR74
#> 1 0.114     1.442  1825    1825 Ashe 37009  37009        5  1091     1      10
#>   BIR79 SID79 NWBIR79                       geometry
#> 1  1364     0      19 MULTIPOLYGON (((-6760648 41...
st_transform_proj(structure(p1, proj4string = "+init=epsg:4326"), "+init=epsg:3857")
#> Warning: GDAL Message 1: +init=epsg:XXXX syntax is deprecated. It might return a CRS with a non-EPSG compliant axis order.
#> POINT (779236.4 6800125)
```
