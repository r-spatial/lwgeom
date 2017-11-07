// [[Rcpp::depends(sf)]]
#include <sf.h>

#include <Rcpp.h>

#include <string.h>

extern "C" {
#include <liblwgeom.h>
}

using namespace Rcpp;

#include "lwgeom.h" // sfc <--> lwgeom

// [[Rcpp::export]]
Rcpp::NumericVector CPL_geodetic_area(Rcpp::List sfc, double semi_major, double inv_flattening) {
	Rcpp::NumericVector ret(sfc.size());
	std::vector<LWGEOM *> lw = lwgeom_from_sfc(sfc);
	SPHEROID s;
	spheroid_init(&s, semi_major, semi_major * (1.0 - 1.0/inv_flattening));
	for (size_t i = 0; i < lw.size(); i++) {
		ret[i] = lwgeom_area_spheroid(lw[i], &s);
		lwgeom_free(lw[i]);
	}
	return ret;
}

// [[Rcpp::export]]
Rcpp::NumericVector CPL_geodetic_length(Rcpp::List sfc, double semi_major, double inv_flattening) {
	Rcpp::NumericVector ret(sfc.size());
	std::vector<LWGEOM *> lw = lwgeom_from_sfc(sfc);
	SPHEROID s;
	spheroid_init(&s, semi_major, semi_major * (1.0 - 1.0/inv_flattening));
	for (size_t i = 0; i < lw.size(); i++) {
		ret[i] = lwgeom_length_spheroid(lw[i], &s);
		lwgeom_free(lw[i]);
	}
	return ret;
}

// [[Rcpp::export]]
Rcpp::List CPL_geodetic_segmentize(Rcpp::List sfc, double max_seg_length) {
	std::vector<LWGEOM *> lw = lwgeom_from_sfc(sfc);
	for (size_t i = 0; i < lw.size(); i++)
		lw[i] = lwgeom_segmentize_sphere(lw[i], max_seg_length);
	return sfc_from_lwgeom(lw);
}

// [[Rcpp::export]]
Rcpp::List CPL_geodetic_covers(Rcpp::List sfc1, Rcpp::List sfc2) {
	Rcpp::List ret(sfc1.size());
	std::vector<LWGEOM *> lw1 = lwgeom_from_sfc(sfc1);
	std::vector<LWGEOM *> lw2 = lwgeom_from_sfc(sfc2);
	for (size_t i = 0; i < sfc1.size(); i++) {
		std::vector<int> idx;
		for (size_t j = 0; j < sfc2.size(); j++)
			if (lwgeom_covers_lwgeom_sphere(lw1[i], lw2[j]))
				idx.push_back(j + 1);
		ret[i] = idx;
	}
	sfc_from_lwgeom(lw1); // free
	sfc_from_lwgeom(lw2); // free
	return ret;
}
