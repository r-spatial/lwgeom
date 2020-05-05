#' @importFrom Rcpp evalCpp
#' @import sf
#' @importFrom utils tail
#' @importFrom units set_units as_units
#' @useDynLib lwgeom
NULL

.onLoad = function(libname, pkgname) {
	# SET PROJ.db path:
	if (file.exists(system.file("proj/nad.lst", package = "sf")[1])) { # we are on Windows:
		prj = system.file("proj", package = "sf")[1]
		CPL_set_data_dir(prj) # if existing, uses C API to set path
		CPL_use_proj4_init_rules(1L)
	}
}

.onAttach = function(libname, pkgname) {
	esv = lwgeom_extSoftVersion()
	m = paste0("Linking to liblwgeom ", esv["lwgeom"],
		", GEOS ", esv["GEOS"],
		", PROJ ", esv["proj.4"])
	CPL_init_lwgeom(NA_character_)
	packageStartupMessage(m)
	sf = sf_extSoftVersion()
	if (sf["GEOS"] != esv["GEOS"])
		warning(paste("GEOS versions differ: lwgeom has", esv["GEOS"], "sf has", sf["GEOS"]))
	if (sf["proj.4"] != esv["proj.4"])
		warning(paste("PROJ versions differ: lwgeom has", esv["proj.4"], "sf has", sf["proj.4"]))

	
}

#' Provide the external dependencies versions of the libraries linked to sf
#' 
#' Provide the external dependencies versions of the libraries linked to sf
#' @export
lwgeom_extSoftVersion = function() {
	structure(c(CPL_lwgeom_version(), CPL_geos_version(), CPL_proj_version()),
		names = c("lwgeom", "GEOS", "proj.4"))
}
