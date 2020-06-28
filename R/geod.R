#' liblwgeom geodetic functions
#' 
#' liblwgeom geodetic functions for length, area, segmentizing, covers
#' @name geod
#' @param x object of class \code{sf}, \code{sfc} or \code{sfg}
#' @export
#' @details \code{st_area} will give an error message when the area spans the equator and \code{lwgeom} is linked to a proj.4 version older than 4.9.0 (see \link{lwgeom_extSoftVersion})
#' @examples
#' library(sf)
#' nc = st_read(system.file("gpkg/nc.gpkg", package="sf"))
#' st_geod_area(nc[1:3,])
#' # st_area(nc[1:3,])
st_geod_area = function(x) {
	stopifnot(st_is_longlat(x))
	p = st_crs(st_geometry(x), parameters = TRUE)
	ret = CPL_geodetic_area(st_geometry(x), p$SemiMajor, p$InvFlattening)
	units(ret) = units(p$SemiMajor^2)
	ret
}

#' @name geod
#' @export
#' @examples
#' l = st_sfc(st_linestring(rbind(c(7,52), c(8,53))), crs = 4326)
#' st_geod_length(l)
st_geod_length = function(x) {
	stopifnot(st_is_longlat(x))
	p = st_crs(st_geometry(x), parameters = TRUE)
	ret = CPL_geodetic_length(st_geometry(x), p$SemiMajor, p$InvFlattening)
	units(ret) = units(p$SemiMajor)
	ret
}

#' @name geod
#' @param max_seg_length segment length in degree, radians, or as a length unit (e.g., m)
#' @export
#' @examples
#' library(units)
#' pol = st_polygon(list(rbind(c(0,0), c(0,60), c(60,60), c(0,0))))
#' x = st_sfc(pol, crs = 4326)
#' seg = st_geod_segmentize(x[1], set_units(10, km))
#' plot(seg, graticule = TRUE, axes = TRUE)
#' @details 
#' longitude coordinates returned are rescaled to [-180,180)
st_geod_segmentize = function(x, max_seg_length) {
	stopifnot(st_is_longlat(x))
	p = st_crs(st_geometry(x), parameters = TRUE)
	if (inherits(max_seg_length, "units")) {
		tr = try(units(max_seg_length) <- as_units("rad"), silent = TRUE)
		if (inherits(tr, "try-error")) {
			units(max_seg_length) = units(p$SemiMajor) # -> m
			max_seg_length = max_seg_length / p$SemiMajor # m -> rad
		}
	} else
		stop("st_geod_segmentize needs a max_seg_length with units rad, degree, or a length unit")
	ret = st_sfc(CPL_geodetic_segmentize(st_geometry(x), max_seg_length))
	st_set_crs((ret + c(180,90)) %% 360 - c(180, 90), st_crs(x)) # rescale lon to [-180,180)
}

#' @name geod
#' @param y object of class \code{sf}, \code{sfc} or \code{sfg}
#' @param sparse logical; if \code{TRUE}, return a sparse matrix (object of class \code{sgbp}), otherwise, return a dense logical matrix.
#' @export
#' @examples
#' pole = st_polygon(list(rbind(c(0,80), c(120,80), c(240,80), c(0,80))))
#' pt = st_point(c(0,90))
#' x = st_sfc(pole, pt, crs = 4326)
#' st_geod_covers(x[c(1,1,1)], x[c(2,2,2,2)])
st_geod_covers = function(x, y, sparse = TRUE) {
	stopifnot(st_is_longlat(x))
	stopifnot(st_is_longlat(y))
	if (!all(st_dimension(x) == 2))
		stop("argument x must contain only polygons")
	if (!all(st_dimension(y) == 0))
		stop("argument y must contain only points")
	if (is.null(id <- row.names(x)))
		id = as.character(seq_along(st_geometry(x)))
	ret = structure(CPL_geodetic_covers(st_geometry(x), st_geometry(y)),
		predicate = "covers", region.id = id, ncol = length(st_geometry(y)), class = "sgbp")
	if (sparse)
		ret
	else
		as.matrix(ret)
}

#' @name geod
#' @export
st_geod_covered_by = function(x, y, sparse = TRUE) {
	ret = structure(t(st_geod_covers(y, x)), predicate = "covered_by")
	if (sparse)
		ret
	else
		as.matrix(ret)
}

#' @name geod
#' @export
#' @param tolerance double or length \code{units} value: if positive, the first distance less than \code{tolerance} is returned, rather than the true distance
#' @note this function should is used by \link[sf:geos_measures]{st_distance}, do not use it directly
#' @examples
#' pole = st_polygon(list(rbind(c(0,80), c(120,80), c(240,80), c(0,80))))
#' pt = st_point(c(30,70))
#' x = st_sfc(pole, pt, crs = 4326)
#' st_geod_distance(x, x)
st_geod_distance = function(x, y, tolerance = 0.0, sparse = FALSE) {
	stopifnot(st_is_longlat(x))
	stopifnot(st_crs(x) == st_crs(y))
	p = st_crs(st_geometry(x), parameters = TRUE)
	SemiMinor = if (is.null(p$SemiMinor)) -1.0 else p$SemiMinor
	units(tolerance) = as_units("m")
	ret = CPL_geodetic_distance(st_geometry(x), st_geometry(y), p$SemiMajor, p$InvFlattening,
		tolerance, sparse, SemiMinor)[[1]]
	if (! sparse) {
		ret[ret < 0] = NA # invalid/incalculable
		units(ret) = units(p$SemiMajor)
		ret
	} else {
		if (is.null(id <- row.names(x)))
			id = as.character(seq_along(st_geometry(x)))
		structure(ret, predicate = "st_is_within_distance", 
			region.id = id, ncol = length(st_geometry(y)), class = "sgbp")
	}
}
