#' Generate the minimum bounding circle
#' @name bounding_circle
#' @param x object of class \code{sfg}, \code{sfc} or \code{sf}
#' @param nQuadSegs number of segments per quadrant (passed to \code{st_buffer})
#' @return Object of the same class as \code{x}
#' @details \code{st_minimum_bounding_circle} uses the \code{lwgeom_calculate_mbc} method also used by the PostGIS command \code{ST_MinimumBoundingCircle}. \code{st_minimum_bounding_radius} also uses the \code{lwgeom_calculate_mbc} method, but returns the centers (as a geometry) and the respective radii (as a column).
#' @examples
#' library(sf)
#'
#' x = st_multipoint(matrix(c(0,1,0,1),2,2))
#' y = st_multipoint(matrix(c(0,0,1,0,1,1),3,2))
#'
#' mbcx = st_minimum_bounding_circle(x)
#' mbcy = st_minimum_bounding_circle(y)
#'
#' if (.Platform$OS.type != "windows") {
#'   plot(mbcx, axes=TRUE); plot(x, add=TRUE)
#'   plot(mbcy, axes=TRUE); plot(y, add=TRUE)
#' }
#' 
#' nc = st_read(system.file("gpkg/nc.gpkg", package="sf"))
#' state = st_union(st_geometry(nc))
#' 
#' if (.Platform$OS.type != "windows") {
#'   plot(st_minimum_bounding_circle(state), asp=1)
#'   plot(state, add=TRUE)
#' }
#'
#' @export
st_minimum_bounding_circle = function(x, nQuadSegs = 30) UseMethod("st_minimum_bounding_circle", x)

generate_circles = function(geom, nQuadSegs = 30) {
  stopifnot(inherits(geom,"sfc"))
  
  circles = CPL_minimum_bounding_circle(geom)
  if (any(is.nan(unlist(circles))))
    stop("NaN values returned by lwgeom's lwgeom_calculate_mbc.") #nocov

  mapply(
    function(xy, r, nQuadSegs) {
      st_buffer(st_point(xy), r, nQuadSegs)
    },
    circles[["center"]], circles[["radius"]],
    MoreArgs = list(nQuadSegs = nQuadSegs),
    SIMPLIFY = FALSE
  )
}

#' @export
st_minimum_bounding_circle.sfg = function(x, nQuadSegs = 30) {
  st_minimum_bounding_circle(st_geometry(x), nQuadSegs)[[1]]
}

#' @export
st_minimum_bounding_circle.sfc = function(x, nQuadSegs = 30) {
  st_sfc(generate_circles(x, nQuadSegs), crs = st_crs(x))
}

#' @export
st_minimum_bounding_circle.sf = function(x, nQuadSegs = 30) {
  st_set_geometry(x, st_minimum_bounding_circle(st_geometry(x), nQuadSegs))
}

#' @rdname bounding_circle
#' @export
st_minimum_bounding_radius = function(x) UseMethod("st_minimum_bounding_radius", x)

generate_radii = function(geom) {
  stopifnot(inherits(geom,"sfc"))
  circles = CPL_minimum_bounding_circle(geom)
  if (any(is.nan(unlist(circles))))
    stop("NaN values returned by lwgeom's lwgeom_calculate_mbc.") #nocov
  centers = st_as_sf(st_sfc(lapply(circles[["center"]], st_point),
                            crs = st_crs(geom)))
  cbind(centers, radius = circles[["radius"]])
}

#' @export
st_minimum_bounding_radius.sfg = function(x) {
  warning("Returning only centers.")
  lapply(CPL_minimum_bounding_circle(x)[["center"]],
         st_point)
}

#' @export
st_minimum_bounding_radius.sfc = function(x) {
  warning("Returning only centers.")
  st_geometry(generate_radii(x))
}

#' @export
st_minimum_bounding_radius.sf = function(x) {
  aux = generate_radii(st_geometry(x))
  out = st_set_geometry(x, st_geometry(aux))
  cbind(out, st_drop_geometry(aux))
}
