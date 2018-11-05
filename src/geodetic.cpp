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
Rcpp::NumericVector CPL_geodetic_azimuth(Rcpp::List sfc, double semi_major, double inv_flattening) {
	if (sfc.size() < 1)
		stop("bearing needs at least 2 points"); // #nocov
	Rcpp::NumericVector ret(sfc.size() - 1);
	std::vector<LWGEOM *> lw = lwgeom_from_sfc(sfc);
	SPHEROID s;
	spheroid_init(&s, semi_major, semi_major * (1.0 - 1.0/inv_flattening));
	for (int i = 0; i < ret.size(); i++) {
		ret[i] = lwgeom_azumith_spheroid((LWPOINT*) lw[i], (LWPOINT*) lw[i+1], &s);
		lwgeom_free(lw[i]);
	}
	lwgeom_free(lw[ret.size()]); // last
	return ret;
}

// [[Rcpp::export]]
Rcpp::List CPL_geodetic_segmentize(Rcpp::List sfc, double max_seg_length) {
	std::vector<LWGEOM *> lw = lwgeom_from_sfc(sfc);
	for (size_t i = 0; i < lw.size(); i++) {
		LWGEOM *ret;
		ret = lwgeom_segmentize_sphere(lw[i], max_seg_length);
		lwgeom_free(lw[i]);
		lw[i] = ret;
	}
	return sfc_from_lwgeom(lw);
}

// [[Rcpp::export]]
Rcpp::List CPL_geodetic_covers(Rcpp::List sfc1, Rcpp::List sfc2) {
	Rcpp::List ret(sfc1.size());
	std::vector<LWGEOM *> lw1 = lwgeom_from_sfc(sfc1);
	std::vector<LWGEOM *> lw2 = lwgeom_from_sfc(sfc2);
	for (size_t i = 0; i < lw1.size(); i++) {
		std::vector<int> idx;
		for (size_t j = 0; j < lw2.size(); j++)
			if (lwgeom_covers_lwgeom_sphere(lw1[i], lw2[j]))
				idx.push_back(j + 1);
		ret[i] = idx;
	}
	sfc_from_lwgeom(lw1); // free
	sfc_from_lwgeom(lw2); // free
	return ret;
}

// [[Rcpp::export]]
Rcpp::List CPL_geodetic_distance(Rcpp::List sfc1, Rcpp::List sfc2, double semi_major,
		double inv_flattening, double tolerance, bool sparse, double semi_minor = -1.0) {
	Rcpp::List out(1);
	std::vector<LWGEOM *> lw1 = lwgeom_from_sfc(sfc1);
	std::vector<LWGEOM *> lw2 = lwgeom_from_sfc(sfc2);
	SPHEROID s;
	if (semi_minor > 0.0)
		spheroid_init(&s, semi_major, semi_minor);
	else
		spheroid_init(&s, semi_major, semi_major * (1.0 - 1.0/inv_flattening)); // #nocov FIXME
	if (sparse) {
		Rcpp::List lst(sfc1.size());
		for (size_t i = 0; i < lw1.size(); i++) {
			Rcpp::IntegerVector iv;
			for (size_t j = 0; j < lw2.size(); j++) {
				if (lwgeom_distance_spheroid(lw1[i], lw2[j], &s, tolerance) <= tolerance)
					iv.push_back(j + 1);
			}
			lst(i) = iv;
		}
		out(0) = lst;
	} else {
		Rcpp::NumericMatrix mat(sfc1.size(), sfc2.size());
		for (size_t i = 0; i < lw1.size(); i++) {
			for (size_t j = 0; j < lw2.size(); j++) {
				mat(i, j) = lwgeom_distance_spheroid(lw1[i], lw2[j], &s, tolerance);
			}
			Rcpp::checkUserInterrupt();
		}
		out(0) = mat;
	}
	sfc_from_lwgeom(lw1); // free
	sfc_from_lwgeom(lw2); // free
	return out;
}
