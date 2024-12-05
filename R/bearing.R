#' compute azimuth between sequence of points
#'
#' compute azimuth between sequence of points
#' @param x object of class \code{sf}, \code{sfc} or \code{sfg}
#' @param y object of class \code{sf}, \code{sfc} or \code{sfg}, or NULL
#' @export
#' @examples
#' library(sf)
#' p = st_sfc(st_point(c(7,52)), st_point(c(8,53)), crs = 4326)
#' st_geod_azimuth(p)
st_geod_azimuth = function(x, y = NULL) {
	stopifnot(st_is_longlat(x))
	stopifnot(all(st_is(x, "POINT")))
	p = st_crs(st_geometry(x), parameters = TRUE)
	if (is.null(y)) {
	  ret = CPL_geodetic_azimuth(st_geometry(x), p$SemiMajor, p$InvFlattening)
	} else {
	  ret = CPL_geodetic_azimuth(st_geometry(x),
	                             p$SemiMajor,
	                             p$InvFlattening,
	                             st_geometry(y))
	}
	units(ret) = as_units("rad")
	ret
}
