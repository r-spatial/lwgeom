#' Return the start and end points from lines
#' 
#' @param x line of class \code{sf}, \code{sfc} or \code{sfg}
#' @export
#' @details see \url{https://postgis.net/docs/ST_StartPoint.html} and \url{https://postgis.net/docs/ST_EndPoint.html}.
#' @return \code{sf} object representing start and end points
#' @examples
#' library(sf)
#' m = matrix(c(0, 1, 2, 0, 1, 4), ncol = 2)
#' # lwgeom::st_startpoint(st_sfc(st_linestring(m))
st_startpoint = function(x) {
	CPL_startpoint(st_geometry(x))
}
