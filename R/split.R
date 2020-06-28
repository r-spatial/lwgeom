#' Return a collection of geometries resulting by splitting a geometry
#' 
#' @name st_split
#' @param x object with geometries to be splitted
#' @param y object split with (blade); if \code{y} contains more than one feature geometry, the geometries are \link[sf:geos_combine]{st_combine} 'd
#' @return object of the same class as \code{x}
#' @examples
#' library(sf)
#' l = st_as_sfc('MULTILINESTRING((10 10, 190 190), (15 15, 30 30, 100 90))')
#' pt = st_sfc(st_point(c(30,30)))
#' st_split(l, pt)
#' @export
st_split = function(x, y) UseMethod("st_split")

#' @export
st_split.sfg = function(x, y) {
	st_split(st_geometry(x), st_geometry(y))[[1]]
}

#' @export
st_split.sfc = function(x, y) {
    if (length(y) > 1) y = sf::st_combine(y)
	if (inherits(x, "sfc_POLYGON") || inherits(x, "sfc_MULTIPOLYGON"))
    	stopifnot(inherits(y, "sfc_LINESTRING") || inherits(y, "sfc_MULTILINESTRING"))
	else
		stopifnot(inherits(x, "sfc_LINESTRING") || inherits(x, "sfc_MULTILINESTRING"))
    st_sfc(CPL_split(x, st_geometry(y)), crs = st_crs(x))
}

#' @export
st_split.sf = function(x, y) {
	st_set_geometry(x, st_split(st_geometry(x), y))
}

#' get substring from linestring
#' @export
#' @param x object of class \code{sfc}, \code{sf} or \code{sfg}
#' @param from relative distance from origin (in [0,1])
#' @param to relative distance from origin (in [0,1])
#' @param ... ignored
#' @param tolerance tolerance parameter, when to snap to line node node
#' @return object of class \code{sfc}
#' @examples
#' library(sf)
#' lines = st_sfc(st_linestring(rbind(c(0,0), c(1,2), c(2,0))), crs = 4326)
#' spl = st_linesubstring(lines, 0.2, 0.8) # should warn
#' plot(st_geometry(lines), col = 'red', lwd = 3)
#' plot(spl, col = 'black', lwd = 3, add = TRUE)
#' st_linesubstring(lines, 0.49999, 0.8) # three points
#' st_linesubstring(lines, 0.49999, 0.8, 0.001) # two points: snap start to second node
st_linesubstring = function(x, from, to, tolerance, ...) UseMethod("st_linesubstring")

#' @export
st_linesubstring.sfc = function(x, from, to, tolerance = 0.0, ...) {
	if (isTRUE(st_is_longlat(x)))
		warning("st_linesubstring does not follow a geodesic; you may want to use st_geod_segmentize first")
	st_sfc(CPL_linesubstring(x, from, to, tolerance), crs = st_crs(x))
}

#' @export
st_linesubstring.sf = function(x, from, to, tolerance = 0.0, ...) {
	if (isTRUE(st_is_longlat(x)))
		warning("st_linesubstring does not follow a geodesic; you may want to use st_geod_segmentize first")
	st_set_geometry(x, st_linesubstring(st_geometry(x), from, to, tolerance))
}

#' @export
st_linesubstring.sfg = function(x, from, to, tolerance = 0.0, ...) {
	CPL_linesubstring(st_geometry(x), from, to, tolerance)[[1]]
}
