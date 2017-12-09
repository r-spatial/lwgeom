#include <iostream>
#include <proj_api.h>

#include "Rcpp.h"

// [[Rcpp::export]]
std::string CPL_proj_version(bool b = false) {
	int v = PJ_VERSION;	
	std::stringstream buffer;
	buffer << v / 100 << "." << (v / 10) % 10 << "." << v % 10;
	return buffer.str();
}
