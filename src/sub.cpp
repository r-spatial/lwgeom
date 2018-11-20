#include <Rcpp.h>

#include <string.h>

extern "C" {
#include <liblwgeom.h>
}

using namespace Rcpp;

#include "lwgeom.h" // sfc <--> lwgeom

// [[Rcpp::export]]
Rcpp::List CPL_linesubstring(Rcpp::List sfc, double from, double to, double tolerance = 0.0) {
	std::vector<LWGEOM *> lw = lwgeom_from_sfc(sfc);
	std::vector<LWGEOM *> out(sfc.size());
	for (size_t i = 0; i < lw.size(); i++) {
		// LWLINE *iline = lwgeom_as_lwline(lw[i]);
		if ( lw[i]->type == LINETYPE ) {
			POINTARRAY *opa;
			opa = ptarray_substring(((LWLINE*)lw[i])->points, from, to, tolerance);
			if ( opa->npoints == 1 ) /* Point returned */
				out[i] = (LWGEOM *)lwpoint_construct(lw[i]->srid, NULL, opa); // #nocov
			else
				out[i] = (LWGEOM *)lwline_construct(lw[i]->srid, NULL, opa);
		} else
			stop("geometry should be of LINE type"); // #nocov
		lwgeom_free(lw[i]);
	}
	return sfc_from_lwgeom(out);
}
