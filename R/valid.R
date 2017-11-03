#' Make an invalid geometry valid
#' @name valid
#' @param x object of class \code{sfg}, \code{sfg} or \code{sf}
#' @return Object of the same class as \code{x}
#' @details \code{st_make_valid} uses the \code{lwgeom_makevalid} method also used by the PostGIS command \code{ST_makevalid}. It is only available if the package was linked against liblwgeom, which is currently not the case for the binary CRAN distributions; see the package source code repository for instructions how to install liblwgeom. The example below shows how to run-time check the availability of liblwgeom.
#' @examples
#' library(sf)
#' x = st_sfc(st_polygon(list(rbind(c(0,0),c(0.5,0),c(0.5,0.5),c(0.5,0),c(1,0),c(1,1),c(0,1),c(0,0)))))
#' suppressWarnings(st_is_valid(x))
#' y = st_make_valid(x)
#' st_is_valid(y)
#' y %>% st_cast()
#' @export
st_make_valid = function(x) UseMethod("st_make_valid")

#' @export
st_make_valid.sfg = function(x) {
	st_make_valid(st_geometry(x))[[1]]
}

#' @export
st_make_valid.sfc = function(x) {
	st_sfc(CPL_make_valid(x), crs = st_crs(x))
}

#' @export
st_make_valid.sf = function(x) {
	st_set_geometry(x, st_make_valid(st_geometry(x)))
}
