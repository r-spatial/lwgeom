#' Return the start and end points from lines
#' 
#' @param x line of class \code{sf}, \code{sfc} or \code{sfg}
#' @export
#' @details see \url{https://postgis.net/docs/ST_StartPoint.html} and \url{https://postgis.net/docs/ST_EndPoint.html}.
#' @return \code{sf} object representing start and end points
#' @examples
#' library(sf)
#' m = matrix(c(0, 1, 2, 0, 1, 4), ncol = 2)
#' l = st_sfc(st_linestring(m))
#' lwgeom::st_startpoint(l)
#' lwgeom::st_endpoint(l)
#' l2 = st_sfc(st_linestring(m), st_linestring(m[3:1, ]))
#' lwgeom::st_startpoint(l2)
#' lwgeom::st_endpoint(l2)
st_startpoint = function(x) {
  m <- CPL_startpoint(st_geometry(x))
  st_sfc(lapply(seq_len(nrow(m)), function(i) st_point(m[i,])), crs = st_crs(x))
}
#' @rdname st_startpoint
#' @export
st_endpoint = function(x) {
  m <- CPL_endpoint(st_geometry(x))
  st_sfc(lapply(seq_len(nrow(m)), function(i) st_point(m[i,])), crs = st_crs(x))
}
