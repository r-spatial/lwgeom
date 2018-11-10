#' compute perimeter from polygons or other geometries
#' 
#' @name perimeter
#' @param x object of class \code{sf}, \code{sfc} or \code{sfg}
#' @return numerical vector with perimeter for each feature (geometry), with unit of measure when possible
#' @export
st_perimeter = function(x) {
	if (isTRUE(st_is_longlat(x)))
		stop("for perimeter of longlat geometry, cast to LINESTRING and use st_length") # nocov
	ret = CPL_perimeter(st_geometry(x), FALSE)
	units(ret) = st_crs(x, parameters=TRUE)$ud_unit
	ret
}

#' @export
#' @name perimeter
st_perimeter_2d = function(x) {
	if (isTRUE(st_is_longlat(x)))
		stop("for perimeter of longlat geometry, cast to LINESTRING and use st_length") # nocov
	ret = CPL_perimeter(st_geometry(x), TRUE)
	units(ret) = st_crs(x, parameters=TRUE)$ud_unit
	ret
}
