#' compute geohash from (average) coordinates
#' 
#' @param x object of class \code{sf}, \code{sfc} or \code{sfg}
#' @param precision integer; precision (length) of geohash returned. From the liblwgeom source: ``where the precision is non-positive, a precision based on the bounds of the feature. Big features have loose precision. Small features have tight precision.''
#' @export
#' @details see \url{http://geohash.org/} or \url{https://en.wikipedia.org/wiki/Geohash}.
#' @return character vector with geohashes
#' @examples
#' library(sf)
#' lwgeom::st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 2)
#' lwgeom::st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 10)
st_geohash = function(x, precision = 0) {
	CPL_geohash(st_geometry(x), precision)
}
