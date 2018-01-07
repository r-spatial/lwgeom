#' @importFrom Rcpp evalCpp
#' @import sf
#' @importFrom units set_units make_unit
#' @useDynLib lwgeom
NULL

.onAttach = function(libname, pkgname) {
	esv = lwgeom_extSoftVersion()
	m = paste0("Linking to liblwgeom ", esv["lwgeom"],
		", GEOS ", esv["GEOS"],
		", proj.4 ", esv["proj.4"])
	CPL_init_lwgeom(NA_character_)
	packageStartupMessage(m)
	sf = sf_extSoftVersion()
	if (sf["GEOS"] != esv["GEOS"])
		warning(paste("GEOS versions differ: lwgeom has", esv["GEOS"], "sf has", sf["GEOS"]))
	if (sf["proj.4"] != esv["proj.4"])
		warning(paste("proj.4 versions differ: lwgeom has", esv["proj.4"], "sf has", sf["proj.4"]))
}

#' Provide the external dependencies versions of the libraries linked to sf
#' 
#' Provide the external dependencies versions of the libraries linked to sf
#' @export
lwgeom_extSoftVersion = function() {
	structure(c(CPL_lwgeom_version(), CPL_geos_version(), CPL_proj_version()),
		names = c("lwgeom", "GEOS", "proj.4"))
}

# redo:
crs_parameters = function(x) {
	if (utils::packageVersion("sf") > "0.5-5")
		st_crs(x, parameters = TRUE)
	else # hard-code the outcome for st_crs(4326):
		structure(list(SemiMajor = structure(6378137, units = structure(list(
    		numerator = "m", denominator = character(0)), .Names = c("numerator", 
		"denominator"), class = "symbolic_units"), class = "units"), 
    		InvFlattening = 298.257223563), .Names = c("SemiMajor", "InvFlattening"
		))
}
