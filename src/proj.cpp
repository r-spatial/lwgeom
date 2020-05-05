#include <iostream>
#include "Rcpp.h"
#ifdef USE_PROJ_H

#include <proj.h>
std::string CPL_proj_version(bool b = false) {
	std::stringstream buffer;
	buffer << PROJ_VERSION_MAJOR << "." << PROJ_VERSION_MINOR << "." << PROJ_VERSION_PATCH;
	return buffer.str();
}

Rcpp::LogicalVector CPL_use_proj4_init_rules(Rcpp::IntegerVector v) {
	proj_context_use_proj4_init_rules(PJ_DEFAULT_CTX, v[0]);
	return true;
}

Rcpp::LogicalVector CPL_set_data_dir(std::string data_dir) {
	const char *cp = data_dir.c_str();
	proj_context_set_search_paths(PJ_DEFAULT_CTX, 1, &cp);
	return true;
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

// [[Rcpp::export]]
Rcpp::LogicalVector CPL_use_proj4_init_rules(Rcpp::IntegerVector v) {
	return false;
}

// [[Rcpp::export]]
Rcpp::LogicalVector CPL_set_data_dir(std::string data_dir) { // #nocov start
	return false;
}

#endif

