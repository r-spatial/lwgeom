// [[Rcpp::depends(sf)]]
#include <sf.h>

#include <Rcpp.h>

#include <string.h>

extern "C" {
#include <liblwgeom.h>
#ifdef HAVE_LIBLWGEOM_INTERNAL_H
# include <liblwgeom_internal.h>
#else /* hard copy from liblwgeom_internal.h: */
# ifndef NO_GRID_IN_PLACE
/*
typedef struct gridspec_t
{
	double ipx;
	double ipy;
	double ipz;
	double ipm;
	double xsize;
	double ysize;
	double zsize;
	double msize;
}
gridspec;
*/
void lwgeom_grid_in_place(LWGEOM *lwgeom, const gridspec *grid);
# endif
#endif
}

#include "lwgeom.h"

using namespace Rcpp; // for _ to work

// [[Rcpp::export]]
Rcpp::CharacterVector CPL_lwgeom_version(bool b = false) {
	return lwgeom_version();
}

// in
std::vector<LWGEOM *> lwgeom_from_sfc(Rcpp::List sfc) {
	std::vector<LWGEOM *> lwgeom_v(sfc.size()); // return
	Rcpp::List wkblst = sf::CPL_write_wkb(sfc, true); // true: write EWKB, puts EPSG inside the wkb
	for (int i = 0; i < wkblst.size(); i++) {
		Rcpp::RawVector rv = wkblst[i];
		const uint8_t *wkb = &(rv[0]); 
		lwgeom_v[i] = lwgeom_from_wkb(wkb, rv.size(),
			LW_PARSER_CHECK_MINPOINTS & LW_PARSER_CHECK_ODD & LW_PARSER_CHECK_CLOSURE);
	}
	return lwgeom_v;
}

// out
Rcpp::List sfc_from_lwgeom(std::vector<LWGEOM *> lwgeom_v) {
	Rcpp::List wkblst(lwgeom_v.size()); 
	for (int i = 0; i < wkblst.size(); i++) {
		size_t size;
		const uint8_t *wkb = lwgeom_to_wkb(lwgeom_v[i], WKB_EXTENDED, &size);
		lwgeom_free(lwgeom_v[i]);
		Rcpp::RawVector raw(size);
		memcpy(&(raw[0]), wkb, size);
		lwfree((void *) wkb);
		wkblst[i] = raw;
	}
	return sf::CPL_read_wkb(wkblst, true, false);
}

// [[Rcpp::export]]
Rcpp::List CPL_sfc_from_twkb(Rcpp::List twkb) {
	std::vector<LWGEOM *> lw(twkb.size());
	for (size_t i = 0; i < lw.size(); i++) {
		Rcpp::RawVector raw = twkb[i];
		lw[i] = lwgeom_from_twkb(&(raw[0]), raw.size(), LW_PARSER_CHECK_ALL);
	}
	return sfc_from_lwgeom(lw);
}


// [[Rcpp::export]]
Rcpp::List CPL_make_valid(Rcpp::List sfc) {

	std::vector<LWGEOM *> lwgeom_v = lwgeom_from_sfc(sfc);
	for (size_t i = 0; i < lwgeom_v.size(); i++) {
		// do the trick:
		LWGEOM *lwg_ret = lwgeom_make_valid(lwgeom_v[i]);
		lwgeom_free(lwgeom_v[i]);
		lwgeom_v[i] = lwg_ret;
	}
	return sfc_from_lwgeom(lwgeom_v);
}

// [[Rcpp::export]]
Rcpp::List CPL_split(Rcpp::List sfc, Rcpp::List blade) {

	std::vector<LWGEOM *> lwgeom_in = lwgeom_from_sfc(sfc);
	std::vector<LWGEOM *> lwgeom_blade = lwgeom_from_sfc(blade);
	for (size_t i = 0; i < lwgeom_in.size(); i++) {
		LWGEOM *lwg_ret = lwgeom_split(lwgeom_in[i], lwgeom_blade[0]);
		lwgeom_free(lwgeom_in[i]);
		lwgeom_in[i] = lwg_ret;
	}
	sfc_from_lwgeom(lwgeom_blade); // free
	return sfc_from_lwgeom(lwgeom_in);
}

// [[Rcpp::export]]
Rcpp::CharacterVector CPL_geohash(Rcpp::List sfc, int prec) {

	Rcpp::CharacterVector chr(sfc.size()); // return
	std::vector<LWGEOM *> lwgeom_v = lwgeom_from_sfc(sfc);
	for (size_t i = 0; i < lwgeom_v.size(); i++) {
		char *c = lwgeom_geohash(lwgeom_v[i], prec);
		chr(i) = c; // copy
		lwfree(c);
		lwgeom_free(lwgeom_v[i]);
	}
	return chr;
}

// [[Rcpp::export]]
Rcpp::List CPL_lwgeom_transform(Rcpp::List sfc, Rcpp::CharacterVector p4s) {
	if (p4s.size() != 2)
		Rcpp::stop("st_lwgeom_transform: p4s needs to be a length 2 character vector\n"); // #nocov
	std::vector<LWGEOM *> lwgeom_v = lwgeom_from_sfc(sfc);
	LWPROJ *pj;
#ifdef USE_PROJ_H
	proj_context_use_proj4_init_rules(PJ_DEFAULT_CTX, 1);
    PJ *P = proj_create_crs_to_crs(PJ_DEFAULT_CTX, p4s[0], p4s[1], NULL);
	if (P == NULL) 
		Rcpp::stop("st_lwgeom_transform: one of the proj strings is invalid\n"); // #nocov
	pj = lwproj_from_PJ(P, 0);
#else
	pj = (LWPROJ *) malloc(sizeof(LWPROJ));
	projPJ src = projpj_from_string(p4s[0]);
	if (src == NULL)
		Rcpp::stop("st_lwgeom_transform: wrong source proj4string\n"); // #nocov
	pj->pj_from = src;
	projPJ target = projpj_from_string(p4s[1]);
	if (target == NULL)
		Rcpp::stop("st_lwgeom_transform: wrong target proj4string\n"); // #nocov
	pj->pj_to = target;
#endif
	for (size_t i = 0; i < lwgeom_v.size(); i++) {
		// in-place transformation w/o GDAL:
		if (lwgeom_transform(lwgeom_v[i], pj) != LW_SUCCESS) {
			Rcpp::Rcout << "Failed on geometry " << i + 1 << std::endl; // #nocov
			Rcpp::stop("st_lwgeom_transform failed\n"); // #nocov
		}
	}
#ifdef USE_PROJ_H
	proj_destroy(P);
#else
	pj_free(src);
	pj_free(target);
	free(pj);
#endif
	Rcpp::List ret = sfc_from_lwgeom(lwgeom_v); // frees lwgeom_v
	// FIXME:
	/*
	Rcpp::List crs = Rcpp::List::create(
		_["epsg"] = NA_INTEGER, 
		_["proj4string"] = CharacterVector::create(p4s[1]));
	crs.attr("class") = "crs";
	ret.attr("crs") = crs;
	*/
	ret.attr("class") = "sfc";
	return ret;
}

// [[Rcpp::export]]
Rcpp::List CPL_minimum_bounding_circle(Rcpp::List sfc) {
  
  Rcpp::List center(sfc.size());
  Rcpp::NumericVector radius(sfc.size());
  
  std::vector<LWGEOM *> lwgeom_v = lwgeom_from_sfc(sfc);
  for (size_t i = 0; i < lwgeom_v.size(); i++) {
    LWBOUNDINGCIRCLE *lwg_ret = lwgeom_calculate_mbc(lwgeom_v[i]);
	if (lwg_ret == NULL)
		Rcpp::stop("could not compute minimum bounding circle"); // #nocov
    center[i] = Rcpp::NumericVector::create(
      Rcpp::Named("x") = lwg_ret->center->x,
      Rcpp::Named("y") = lwg_ret->center->y
    );
    radius[i] = lwg_ret->radius;
    lwgeom_free(lwgeom_v[i]);
	lwboundingcircle_destroy(lwg_ret);
  }
  return Rcpp::List::create(
    Rcpp::Named("center") = center,
    Rcpp::Named("radius") = radius
  );
}

// [[Rcpp::export]]
Rcpp::List CPL_subdivide(Rcpp::List sfc, int max_vertices = 256) {
  
	std::vector<LWGEOM *> lwgeom_v = lwgeom_from_sfc(sfc);

	for (size_t i = 0; i < lwgeom_v.size(); i++)
		lwgeom_v[i] = lwcollection_as_lwgeom(lwgeom_subdivide(lwgeom_v[i], max_vertices));
	return sfc_from_lwgeom(lwgeom_v);
}

// [[Rcpp::export]]
Rcpp::List CPL_snap_to_grid(Rcpp::List sfc, Rcpp::NumericVector origin, Rcpp::NumericVector size) {
#ifdef NO_GRID_IN_PLACE
	Rcpp::stop("st_snap_to_grid: not supported in this version of liblwgeom\n"); // #nocov
	// return sfc;
#else
	// initialize input data
	std::vector<LWGEOM *> lwgeom_v = lwgeom_from_sfc(sfc);
	// initialize grid
	gridspec grid;
	grid.ipx = origin[0];
	grid.ipy = origin[1];
	grid.ipz = origin[2];
	grid.ipm = origin[3];
	grid.xsize = size[0];
	grid.ysize = size[1];
	grid.zsize = size[2];
	grid.msize = size[3];
	// snap geometries to grid
	for (size_t i = 0; i < lwgeom_v.size(); i++)
		lwgeom_grid_in_place(lwgeom_v[i], &grid);
	// return snapped geometries
	return sfc_from_lwgeom(lwgeom_v); 
#endif
}

// [[Rcpp::export]]
Rcpp::NumericVector CPL_perimeter(Rcpp::List sfc, bool do2d = false) {
	Rcpp::NumericVector out(sfc.length());
	std::vector<LWGEOM *> lwgeom_v = lwgeom_from_sfc(sfc);

	if (do2d) {
		for (size_t i = 0; i < lwgeom_v.size(); i++)
			out[i] = lwgeom_perimeter_2d(lwgeom_v[i]);
	} else {
		for (size_t i = 0; i < lwgeom_v.size(); i++)
			out[i] = lwgeom_perimeter(lwgeom_v[i]);
	}
	return out;
}


// [[Rcpp::export]]
Rcpp::LogicalVector CPL_is_polygon_cw(Rcpp::List sfc) {
  std::vector<LWGEOM *> lwgeom_cw = lwgeom_from_sfc(sfc);
  Rcpp::LogicalVector out(sfc.length());
  for (size_t i = 0; i < lwgeom_cw.size(); i++) {
    out[i] = lwgeom_is_clockwise(lwgeom_cw[i]);
    lwgeom_free(lwgeom_cw[i]);
  }
  return out;
}

// [[Rcpp::export]]
Rcpp::List CPL_force_polygon_cw(Rcpp::List sfc) {
  
  std::vector<LWGEOM *> lwgeom_cw = lwgeom_from_sfc(sfc);
  for (size_t i = 0; i < lwgeom_cw.size(); i++) {
    lwgeom_force_clockwise(lwgeom_cw[i]);
  }
  return sfc_from_lwgeom(lwgeom_cw);
}

// [[Rcpp::export]]
Rcpp::NumericMatrix CPL_startpoint(Rcpp::List sfc) {
  
  std::vector<LWGEOM *> lwgeom_cw = lwgeom_from_sfc(sfc);
  Rcpp::NumericMatrix m(lwgeom_cw.size(), 2);
  
  POINT4D p;
  for (size_t i = 0; i < lwgeom_cw.size(); i++) {
    lwgeom_startpoint(lwgeom_cw[i], &p);
    m(i, 0) = p.x;
    m(i, 1) = p.y;
  }
  
  return m;
  // next step: get it into sf form
  // return sfc_from_lwgeom(lwgeom_cw);
}

// [[Rcpp::export]]
Rcpp::NumericMatrix CPL_endpoint(Rcpp::List sfc) {
  
  std::vector<LWGEOM *> lwgeom_cw = lwgeom_from_sfc(sfc);
  Rcpp::NumericMatrix m(lwgeom_cw.size(), 2);
  
  // no lwgeom_endpoint so reverse in-place and use startpoint
  POINT4D p;
  for (size_t i = 0; i < lwgeom_cw.size(); i++) {
    lwgeom_reverse_in_place(lwgeom_cw[i]);
    lwgeom_startpoint(lwgeom_cw[i], &p);
    m(i, 0) = p.x;
    m(i, 1) = p.y;
  }
  
  return m;
}


// [[Rcpp::export]]
Rcpp::CharacterVector CPL_sfc_to_wkt(Rcpp::List sfc, Rcpp::IntegerVector precision) {

  std::vector<LWGEOM *> lwgeom_cw = lwgeom_from_sfc(sfc);
  Rcpp::CharacterVector out;
  for (size_t i = 0; i < lwgeom_cw.size(); i++) {
	char *wkt = lwgeom_to_wkt(lwgeom_cw[i], WKT_EXTENDED, precision[0], NULL);
    out.push_back(wkt);
	free(wkt);
  }
  return out;
}
