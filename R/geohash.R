#' compute geohash from (average) coordinates
#' 
#' @param x object of class \code{sf}, \code{sfc} or \code{sfg}
#' @param precision integer; precision (length) of geohash returned. From the liblwgeom source: ``where the precision is non-positive, a precision based on the bounds of the feature. Big features have loose precision. Small features have tight precision.''
#' @export
#' @details see \url{http://geohash.org/} or \url{https://en.wikipedia.org/wiki/Geohash}.
#' @return `st_geohash` returns a character vector with geohashes; empty or full geometries result in `NA`
#' 
#' `st_geom_from_geohash` returns a (bounding box) polygon for each geohash if `raw` is `FALSE`, if `raw` is `TRUE` a matrix is returned with bounding box coordinates on each row.
#' @examples
#' library(sf)
#' lwgeom::st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 2)
#' lwgeom::st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 10)
st_geohash = function(x, precision = 0) {
	x = st_geometry(x)
	ret = vector("character", length(x))
	is_na = st_is_empty(x) | st_is_full(x)
	ret[is_na] = NA_character_
	ret[!is_na] = CPL_geohash(x[!is_na], precision)
	ret
}

#' @export
#' @name st_geohash
#' @param hash character vector with geohashes
#' @param raw logical; if `TRUE`, return a matrix with bounding box coordinates on each row
#' @param crs object of class `crs`
#' @examples
#' st_geom_from_geohash(c('9qqj7nmxncgyy4d0dbxqz0', 'up'), raw = TRUE)
#' o = options(digits = 20) # for printing purposes
#' st_geom_from_geohash(c('9qqj7nmxncgyy4d0dbxqz0', 'u1hzz631zyd63zwsd7zt'))
#' st_geom_from_geohash('9qqj7nmxncgyy4d0dbxqz0', 4) 
#' st_geom_from_geohash('9qqj7nmxncgyy4d0dbxqz0', 10)
#' options(o)
st_geom_from_geohash = function(hash, precision = -1, crs = st_crs('OGC:CRS84'), raw = FALSE) {
	stopifnot(is.character(hash), is.numeric(precision), length(precision) == 1)
	m = CPL_bbox_from_geohash(hash, as.integer(precision))
	bb = matrix(m, nrow = 4)
	rownames(bb) = c("xmin", "ymin", "xmax", "ymax")
	if (raw)
		t(bb)
	else { 
		bb = apply(bb, 2, sf::st_bbox, simplify = FALSE)
		sf::st_set_crs(do.call(c, lapply(bb, sf::st_as_sfc)), crs)
	}
}
