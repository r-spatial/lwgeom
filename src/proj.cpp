#include <iostream>
#include "Rcpp.h"
#ifdef USE_PROJ_H

#include <proj.h>
std::string CPL_proj_version(bool b = false) {
	std::stringstream buffer;
	buffer << PROJ_VERSION_MAJOR << "." << PROJ_VERSION_MINOR << "." << PROJ_VERSION_PATCH;
	return buffer.str();
}

#else

#include <proj_api.h>
// [[Rcpp::export]]
std::string CPL_proj_version(bool b = false) {
	int v = PJ_VERSION;	
	std::stringstream buffer;
	buffer << v / 100 << "." << (v / 10) % 10 << "." << v % 10;
	return buffer.str();
}

#endif
