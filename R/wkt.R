#' Return Well-known Text representation of simple feature geometry
#'
#' Return Well-known Text representation of simple feature geometry or coordinate reference system
#' @param x object of class `sfg`, `sfc`, or `sf`
#' @param digits integer; number of decimal digits to print
#' @param ... ignored
#' @param EWKT logical; use PostGIS Enhanced WKT (includes srid)
#' @name st_astext
#' @details The returned WKT representation of simple feature geometry conforms to the
#' [simple features access](http://www.opengeospatial.org/standards/sfa) specification and extensions (if `EWKT = TRUE`),
#' [known as EWKT](http://postgis.net/docs/using_postgis_dbmanagement.html#EWKB_EWKT), supported by
#' PostGIS and other simple features implementations for addition of SRID to a WKT string.
#' @md
#' @examples 
#' library(sf)
#' pt <- st_sfc(st_point(c(1.0002,2.3030303)), crs = 4326)
#' st_astext(pt, 3)
#' st_asewkt(pt, 3)
#' @export
st_astext <- function(x, digits = options("digits"), ..., EWKT = FALSE) {
  if (! EWKT && !inherits(x, "sfg"))
    st_crs(x) <- NA_crs_
  CPL_sfc_to_wkt(st_geometry(x), as.integer(digits))
}

#' @name st_astext
#' @inheritParams st_astext
#' @details `st_asewkt()` returns the Well-Known Text (WKT) representation of 
#' the geometry with SRID meta data.
#' @md
#' @export
st_asewkt <- function(x, digits = options("digits")) {
  st_astext(x, digits = digits, EWKT = TRUE)
}
