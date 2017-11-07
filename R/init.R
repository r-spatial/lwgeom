#' @importFrom Rcpp evalCpp
#' @import sf
#' @importFrom units set_units
#' @useDynLib lwgeom
NULL

.onAttach = function(libname, pkgname) {
	m = paste("Linking to lwgeom", CPL_lwgeom_version())
	packageStartupMessage(m)
}

#' Provide the external dependencies versions of the libraries linked to sf
#' 
#' Provide the external dependencies versions of the libraries linked to sf
#' @export
lwgeom_extSoftVersion = function() {
	structure(CPL_lwgeom_version(), names = c("lwgeom"))
}
