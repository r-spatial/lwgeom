#' compute perimeter from polygons or other geometries
#' 
#' @name perimeter
#' @param x object of class \code{sf}, \code{sfc} or \code{sfg}
#' @export
st_perimeter = function(x) {
	if (st_is_longlat(x))
		stop("for perimeter of longlat geometry, cast to LINESTRING and use st_length") # nocov
	CPL_perimeter(st_geometry(x), FALSE)
}

#' @export
#' @name perimeter
st_perimeter_2d = function(x) {
	if (st_is_longlat(x))
		stop("for perimeter of longlat geometry, cast to LINESTRING and use st_length") # nocov
	CPL_perimeter(st_geometry(x), TRUE)
}
