#define GEOS_USE_ONLY_R_API // prevents using non-thread-safe GEOSxx functions without _r extension.
#include <geos_c.h>

#include <Rcpp.h>

// [[Rcpp::export]]
std::string CPL_geos_version(bool b = false) {
	return GEOS_VERSION;
}
