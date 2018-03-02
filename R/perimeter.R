#' compute perimeter from polygons or other geometries
#' 
#' @name perimeter
#' @param x object of class \code{sf}, \code{sfc} or \code{sfg}
#' @export
st_perimeter = function(x) {
	CPL_perimeter(st_geometry(x), FALSE)
}

#' @export
#' @name perimeter
st_perimeter_2d = function(x) {
	CPL_perimeter(st_geometry(x), TRUE)
}
