#' Snap geometries to a grid
#' 
#' @name st_snap_to_grid
#' @param x object with geometries to be snapped
#' @param size numeric or (length) units object; grid cell size in x-, y- (and possibly z- and m-) directions
#' @param origin numeric; origin of the grid
#' @return object of the same class as \code{x}
#' @examples
#' # obtain data
#' library(sf)
#' x = st_read(system.file("gpkg/nc.gpkg", package="sf"), quiet = TRUE)[1, ] %>%
#'     st_geometry %>%
#'     st_transform(3395)
#'
#' # snap to a grid of 5000 m
#' err = try(y <- st_snap_to_grid(x, 5000))
#'
#' # plot data for visual comparison
#' if (!inherits(err, "try-error")) {
#'  opar = par(mfrow = c(1, 2))
#'  plot(x, main = "orginal data")
#'  plot(y, main = "snapped to 5000 m")
#'  par(opar)
#' }
#' @export
st_snap_to_grid = function(x, size, origin) UseMethod("st_snap_to_grid")

#' @export
st_snap_to_grid.sfg = function(x, size, origin = st_point(rep(0.0,4))) {
	st_snap_to_grid(st_geometry(x), size, origin)[[1]]
}

#' @export
st_snap_to_grid.sfc = function(x, size, origin = st_point(rep(0.0,4))) {
	size = rep(as.numeric(size), length.out = 4)
	stopifnot(!isTRUE(st_is_longlat(x))) # FIXME
	units(size) = as_units("m")
	st_sfc(CPL_snap_to_grid(x, origin, size), crs = st_crs(x))
}

#' @export
st_snap_to_grid.sf = function(x, size, origin = st_point(rep(0.0,4))) {
	st_set_geometry(x, st_snap_to_grid(st_geometry(x), size, origin))
}
