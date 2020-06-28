#' Make an invalid geometry valid
#'
#' Make an invalid geometry valid
#' @param x object of class \code{sfc}
#' @export
lwgeom_make_valid = function(x) {
	stopifnot(inherits(x, "sfc"))
	st_sfc(CPL_make_valid(x), crs = st_crs(x))
}
