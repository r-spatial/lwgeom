#' create sfc object from tiny well-known binary (twkb)
#'
#' create sfc object from tiny well-known binary (twkb)
#' @param x list with raw vectors, of class \code{TWKB}
#' @param ... ignored
#' @seealso https://github.com/TWKB/Specification/blob/master/twkb.md
#' @examples
#' l = structure(list(as.raw(c(0x02, 0x00, 0x02, 0x02, 0x02, 0x08, 0x08))), class = "TWKB")
#' library(sf) # load generic
#' st_as_sfc(l)
#' @export
st_as_sfc.TWKB = function(x, ...) {
	st_sfc(CPL_sfc_from_twkb(x))
}
