#' Return a collection of geometries resulting by subdividing a geometry
#' 
#' @name st_subdivide
#' @param x object with geometries to be subdivided
#' @param max_vertices integer; maximum size of the subgeometries (at least 8)
#' @return object of the same class as \code{x}
#' @examples
#' library(sf)
#' demo(nc, ask = FALSE, echo = FALSE)
#' x = st_subdivide(nc, 10)
#' plot(x[1])
#' @export
st_subdivide = function(x, max_vertices) UseMethod("st_subdivide")

#' @export
st_subdivide.sfg = function(x, max_vertices = 256) {
	st_subdivide(st_geometry(x), max_vertices)[[1]]
}

#' @export
st_subdivide.sfc = function(x, max_vertices = 256) {
    st_sfc(CPL_subdivide(x, max_vertices), crs = st_crs(x))
}

#' @export
st_subdivide.sf = function(x, max_vertices = 256) {
	st_set_geometry(x, st_subdivide(st_geometry(x), max_vertices))
}
