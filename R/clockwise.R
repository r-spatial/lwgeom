#' Force a POLYGON or MULTIPOLYGON to be clockwise
#' 
#' Check if a POLYGON or MULTIPOLYGON is clockwise, and if not make it so. 
#' According to the 'Right-hand-rule', outer rings should be clockwise, and 
#' inner holes should be counter-clockwise
#' 
#' 
#' @name st_force_polygon_cw
#' @param x object with polygon geometries
#' @return object of the same class as \code{x}
#' @export
#' 
#' @examples 
#' library(sf)
#' polys <- st_sf(cw = c(FALSE, TRUE), 
#'                st_as_sfc(c('POLYGON ((0 0, 1 0, 1 1, 0 0))', 
#'                            'POLYGON ((1 1, 2 2, 2 1, 1 1))')))
#'
#' st_force_polygon_cw(polys)
#' st_force_polygon_cw(st_geometry(polys))
#' st_force_polygon_cw(st_geometry(polys)[[1]])
st_force_polygon_cw = function(x) UseMethod("st_force_polygon_cw")

#' @export
st_force_polygon_cw.sfg = function(x) {
	st_force_polygon_cw(st_geometry(x))[[1]]
}

#' @export
st_force_polygon_cw.sfc = function(x) {
  st_sfc(CPL_force_polygon_cw(x), crs = st_crs(x))
}

#' @export
st_force_polygon_cw.sf = function(x) {
	st_set_geometry(x, st_force_polygon_cw(st_geometry(x)))
}

#' Check if a POLYGON or MULTIPOLYGON is clockwise
#' 
#' Check if a POLYGON or MULTIPOLYGON is clockwise. According to the 
#' 'Right-hand-rule', outer rings should be clockwise, and inner holes
#' should be counter-clockwise
#' 
#' @name st_is_polygon_cw
#' @param x object with polygon geometries
#' @return logical with length the same number of features in `x`
#' @export
#' 
#' @examples 
#' library(sf)
#' polys <- st_sf(cw = c(FALSE, TRUE), 
#'                st_as_sfc(c('POLYGON ((0 0, 1 0, 1 1, 0 0))', 
#'                            'POLYGON ((1 1, 2 2, 2 1, 1 1))')))
#' 
#' st_is_polygon_cw(polys)
#' st_is_polygon_cw(st_geometry(polys))
#' st_is_polygon_cw(st_geometry(polys)[[1]])
st_is_polygon_cw = function(x) UseMethod("st_is_polygon_cw")

#' @export
st_is_polygon_cw.sfg = function(x) {
  st_is_polygon_cw(st_geometry(x))[[1]]
}

#' @export
st_is_polygon_cw.sfc = function(x) {
  CPL_is_polygon_cw(x)
}

#' @export
st_is_polygon_cw.sf = function(x) {
  st_is_polygon_cw(st_geometry(x))
}
