context("lwgeom")

test_that("st_make_valid works", {
	library(sf)
	x = st_sfc(st_polygon(list(rbind(c(0,0),c(0.5,0),c(0.5,0.5),c(0.5,0),c(1,0),c(1,1),c(0,1),c(0,0)))))
	fls = suppressWarnings(st_is_valid(x, FALSE))
	expect_false(fls)

   	y = st_make_valid(x)
	expect_true(st_is_valid(y))
   	expect_true(st_is_valid(st_make_valid(x[[1]])))
   	expect_true(st_is_valid(st_make_valid(st_sf(a = 1, geom = x))))
	expect_equal(st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 2), c( "s0","up"))
	expect_equal(st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 10), c("s095fjhkbx","upbpbpbpbp"))
	l = st_as_sfc('MULTILINESTRING((10 10, 190 190), (15 15, 30 30, 100 90))')
	pt = st_sfc(st_point(c(30,30)))
	expect_silent(st_split(l, pt)) # sfc
	expect_silent(st_split(l[[1]], pt)) # sfg
	expect_silent(st_split(st_sf(a = 1, geom = l), pt)) # sf
	# https://github.com/r-spatial/sf/issues/509 :
	p1 = st_point(c(7,52))
	geom.sf = st_sfc(p1, crs = 4326)
	x <- st_transform_proj(geom.sf, "+proj=wintri")
	p = st_crs(4326)$proj4string
	x <- st_transform_proj(structure(geom.sf[[1]], proj4string = p), "+proj=wintri")
	nc = st_read(system.file("shape/nc.shp", package="sf"))
	st_transform_proj(nc[1,], "+proj=wintri +over")
	lwgeom_extSoftVersion()
})

test_that("st_minimum_bounding_circle works", {
  library(sf)
  x = st_multipoint(matrix(c(0,1,0,1),2,2))
  y = st_multipoint(matrix(c(0,0,1,0,1,1),3,2))
  plot(st_minimum_bounding_circle(x), axes=TRUE); plot(x, add=TRUE)
  plot(st_minimum_bounding_circle(y), axes=TRUE); plot(y, add=TRUE)
  nc = st_read(system.file("shape/nc.shp", package="sf"))
  state = st_union(st_geometry(nc))
  plot(st_minimum_bounding_circle(state), asp=1)
  plot(st_minimum_bounding_circle(st_sf(st = "nc", geom = state)), asp=1)
  plot(state, add=TRUE)
})
