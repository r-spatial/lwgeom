#' liblwgeom geodetic functions
#' 
#' liblwgeom geodetic functions for length, area, segmentizing, covers
#' @name lw_geodetic
#' @param x object of class \code{sf}, \code{sfc} or \code{sfg}
#' @export
#' @examples
#' library(sf)
#' nc = st_read(system.file("gpkg/nc.gpkg", package="sf"))
#' st_geod_area(nc[1:3,])
#' # st_area(nc[1:3,])
st_geod_area = function(x) {
	stopifnot(st_is_longlat(x))
	p = crs_parameters(x)
	ret = CPL_geodetic_area(st_geometry(x), p$SemiMajor, p$InvFlattening)
	units(ret) = units(p$SemiMajor^2)
	ret
}

#' @name lw_geodetic
#' @export
#' @examples
#' l = st_sfc(st_linestring(rbind(c(7,52), c(8,53))), crs = 4326)
#' st_geod_length(l)
st_geod_length = function(x) {
	stopifnot(st_is_longlat(x))
	p = crs_parameters(x)
	ret = CPL_geodetic_length(st_geometry(x), p$SemiMajor, p$InvFlattening)
	units(ret) = units(p$SemiMajor)
	ret
}

#' @name lw_geodetic
#' @param max_seg_length segment length in radians, or as a distance units
#' @export
#' @examples
#' library(units)
#' pol = st_polygon(list(rbind(c(0,0), c(0,60), c(60,60), c(0,0))))
#' x = st_sfc(pol, crs = 4326)
#' seg = st_geod_segmentize(x[1], set_units(10, km))
#' plot(seg, graticule = TRUE, axes = TRUE)
st_geod_segmentize = function(x, max_seg_length) {
	stopifnot(st_is_longlat(x))
	p = crs_parameters(x)
	if (inherits(max_seg_length, "units")) {
		units(max_seg_length) = units(p$SemiMajor)
		max_seg_length = max_seg_length / p$SemiMajor # rad
	}
	st_sfc(CPL_geodetic_segmentize(st_geometry(x), max_seg_length), crs = st_crs(x))
}

#' @name lw_geodetic
#' @param y object of class \code{sf}, \code{sfc} or \code{sfg}
#' @export
#' @examples
#' pole = st_polygon(list(rbind(c(0,80), c(120,80), c(240,80), c(0,80))))
#' pt = st_point(c(0,90))
#' x = st_sfc(pole, pt, crs = 4326)
#' st_geod_covers(x[c(1,1,1)], x[c(2,2,2,2)])
st_geod_covers = function(x, y) {
	stopifnot(st_is_longlat(x))
	stopifnot(st_is_longlat(y))
	if (!all(st_dimension(x) == 2))
		stop("argument x must contain only polygons")
	if (!all(st_dimension(y) == 0))
		stop("argument x must contain only points")
	if (is.null(id <- row.names(x)))
		id = as.character(seq_along(st_geometry(x)))
	structure(CPL_geodetic_covers(st_geometry(x), st_geometry(y)),
		predicate = "covers", region.id = id, ncol = length(st_geometry(y)), class = "sgbp")
}
