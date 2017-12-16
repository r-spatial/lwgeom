#' Return a collection of geometries resulting by splitting a geometry
#' 
#' @name st_split
#' @param x object with geometries to be splitted
#' @param y object split with (blade); if \code{y} contains more than one feature geometry, the geometries are \link{st_combine}d
#' @return object of the same class as \code{x}
#' @examples
#' library(sf)
#' l = st_as_sfc('MULTILINESTRING((10 10, 190 190), (15 15, 30 30, 100 90))')
#' pt = st_sfc(st_point(c(30,30)))
#' lwgeom::st_split(l, pt)
#' @export
st_split = function(x, y) UseMethod("st_split")

#' @export
st_split.sfg = function(x, y) {
	st_split(st_geometry(x), st_geometry(y))[[1]]
}

#' @export
st_split.sfc = function(x, y) {
    stopifnot(length(y) == 1)
	if (inherits(x, "sfc_POLYGON") || inherits(x, "sfc_MULTIPOLYGON"))
    	stopifnot(inherits(y, "sfc_LINESTRING"))
	else
		stopifnot(inherits(x, "sfc_LINESTRING") || inherits(x, "sfc_MULTILINESTRING"))
    st_sfc(CPL_split(x, st_geometry(y)), crs = st_crs(x))
}

#' @export
st_split.sf = function(x, y) {
	st_set_geometry(x, st_split(st_geometry(x), y))
}
