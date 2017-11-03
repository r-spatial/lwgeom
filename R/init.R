#' @importFrom Rcpp evalCpp
#' @import sf
#' @useDynLib lwgeom
NULL

#' Provide version of the link lwgeom library
#'
#' Provide version of the link lwgeom library
#' @export
lwgeom_version = function() {
  CPL_lwgeom_version()
}
