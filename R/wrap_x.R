#' Splits input geometries by a vertical line and moves components falling on
#' one side of that line by a fixed amount
#' 
#' @name st_wrap_x
#' @param x object with geometries to be split
#' @param wrap x value of split line
#' @param move amount by which geometries falling to the left of the line
#'             should be translated to the right
#' @return object of the same class as \code{x}
#' @examples
#' library(sf)
#' demo(nc, ask = FALSE, echo = FALSE)
#' x = st_wrap_x(nc, -78, 10)
#' plot(x[1])
#' @export
st_wrap_x = function(x, wrap, move) UseMethod("st_wrap_x")

#' @export
st_wrap_x.sfg = function(x, wrap, move) {
	st_wrap_x(st_geometry(x), wrap, move)[[1]]
}

#' @export
st_wrap_x.sfc = function(x, wrap, move) {
    st_sfc(CPL_wrap_x(x, wrap, move), crs = st_crs(x))
}

#' @export
st_wrap_x.sf = function(x, wrap, move) {
	st_set_geometry(x, st_wrap_x(st_geometry(x), wrap, move))
}
