#' Return Well-known Text representation of simple feature geometry
#'
#' Return Well-known Text representation of simple feature geometry or coordinate reference system
#' @param x object of class `sfg`, `sfc` or `crs``
#' @param precision number of digits to print
#' @param EWKT Use Postgis Enhanced WKT (includes srid)
#' @name st_astext
#' @details The returned WKT representation of simple feature geometry conforms to the
#' [simple features access](http://www.opengeospatial.org/standards/sfa) specification and extensions (if `EWKT = TRUE`),
#' [known as EWKT](http://postgis.net/docs/using_postgis_dbmanagement.html#EWKB_EWKT), supported by
#' PostGIS and other simple features implementations for addition of SRID to a WKT string.
#' @md
#' @examples 
#' library(sf)
#' pt <- st_sfc(st_point(c(1.0002,2.3030303)), crs = 4326)
#' st_astext(pt, 3, TRUE)
#' @export
st_astext <- function(x, precision = 12, EWKT = FALSE) {
  if (!EWKT) st_crs(x) <- NA_crs_
  CPL_sfc_to_wkt(x, precision = precision)
}

#' @name st_astext
#' @inheritParams st_astext
#' @details `st_asewkt()` returns the Well-Known Text (WKT) representation of 
#' the geometry with SRID meta data.
#' @md
#' @export
st_asewkt <- function(x, precision) {
  st_astext(x, precision, EWKT = TRUE)
}
