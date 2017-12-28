#' Snap geometries to a grid
#' 
#' @name st_snap_to_grid
#' @param x object with geometries to be snapped
#' @param tolerance double; tolerance value
#' @return object of the same class as \code{x}
#' @examples
#' # obtain data
#' library(sf)
#' x = st_read(system.file("gpkg/nc.gpkg", package="sf"), quiet = TRUE)[1, ] %>%
#'     st_geometry %>%
#'     st_transform(3395)
#'
#' # snap to a grid of 5000 m
#' y = st_snap_to_grid(x, 5000)
#'
#' # plot data for visual comparison
#' par(mfrow = c(1, 2))
#' plot(x, main = "orginal data")
#' plot(y, main = "snapped to 5000 m")
#' @export
st_snap_to_grid = function(x, tolerance) UseMethod("st_snap_to_grid")

#' @export
st_snap_to_grid.sfg = function(x, tolerance) {
	st_snap_to_grid(st_geometry(x), tolerance)[[1]]
}

#' @export
st_snap_to_grid.sfc = function(x, tolerance) {
	stopifnot(length(tolerance) == 1)
	stopifnot(!isTRUE(st_is_longlat(x)))
	units(tolerance) = make_unit("m")
	st_sfc(CPL_snap_to_grid(x, tolerance), crs = st_crs(x))
}

#' @export
st_snap_to_grid.sf = function(x, tolerance) {
	st_set_geometry(x, st_snap_to_grid(st_geometry(x), tolerance))
}
