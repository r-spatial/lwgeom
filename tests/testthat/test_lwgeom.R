context("lwgeom")

test_that("st_make_valid works", {
	library(sf)
	x = st_sfc(st_polygon(list(rbind(c(0,0),c(0.5,0),c(0.5,0.5),c(0.5,0),c(1,0),c(1,1),c(0,1),c(0,0)))))
	fls = suppressWarnings(sf::st_is_valid(x, FALSE))
	expect_false(fls)

   	y = st_make_valid(x)
	expect_true(st_is_valid(y))
   	expect_true(st_is_valid(st_make_valid(x[[1]])))
   	expect_true(st_is_valid(lwgeom_make_valid(x)))
   	expect_true(st_is_valid(st_make_valid(st_sf(a = 1, geom = x))))
	expect_equal(lwgeom::st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 2), c( "s0","up"))
	expect_equal(lwgeom::st_geohash(st_sfc(st_point(c(1.5,3.5)), st_point(c(0,90))), 10),
		c("s095fjhkbx","upbpbpbpbp"))
	l = st_as_sfc('MULTILINESTRING((10 10, 190 190), (15 15, 30 30, 100 90))')
	pt = st_sfc(st_point(c(30,30)))
	expect_silent(lwgeom::st_split(l, pt)) # sfc
	expect_silent(lwgeom::st_split(l[[1]], pt)) # sfg
	expect_silent(lwgeom::st_split(st_sf(a = 1, geom = l), pt)) # sf
	# https://github.com/r-spatial/sf/issues/509 :
	p1 = st_point(c(7,52))
	geom.sf = st_sfc(p1, crs = 4326)
	x <- st_transform_proj(geom.sf, "+proj=wintri")
	if (sf_extSoftVersion()["proj.4"] >= "6.0.0") {
		x2 <- st_transform_proj(geom.sf, c("EPSG:4326", "+proj=wintri"))
	}
	x3 <- st_transform_proj(geom.sf, st_crs(3857))
	p = st_crs(4326)$proj4string
	x <- st_transform_proj(structure(geom.sf[[1]], proj4string = p), "+proj=wintri")
	nc = st_read(system.file("gpkg/nc.gpkg", package="sf"), quiet = TRUE)
	st_transform_proj(nc[1,], "+proj=wintri +over")
	lwgeom_extSoftVersion()
})

test_that("st_minimum_bounding_circle works", {
  library(sf)
  x = st_multipoint(matrix(c(0,1,0,1),2,2))
  y = st_multipoint(matrix(c(0,0,1,0,1,1),3,2))
  plot(st_minimum_bounding_circle(x), axes=TRUE); plot(x, add=TRUE)
  plot(st_minimum_bounding_circle(y), axes=TRUE); plot(y, add=TRUE)
  nc = st_read(system.file("shape/nc.shp", package="sf"), quiet = TRUE)
  state = st_union(st_geometry(nc))
  st_minimum_bounding_circle(state)
  st_minimum_bounding_circle(st_sf(st = "nc", geom = state))
})

test_that("st_subdivide works", {
	library(sf)
	x = st_read(system.file("gpkg/nc.gpkg", package="sf"), quiet = TRUE)
	expect_silent(st_subdivide(x, 10))
	expect_silent(st_subdivide(st_geometry(x), 10))
	expect_silent(st_subdivide(st_geometry(x)[[1]], 10))
})

test_that("st_snap_to_grid_works", {
	# make data
	library(sf)
	x = st_read(system.file("gpkg/nc.gpkg", package="sf"), quiet = TRUE) %>%
			st_transform(3395)
	# snap to grid
	err <- try(y1 <- st_snap_to_grid(x, 5000), silent = TRUE)
	if (inherits(err, "try-error")) # not available in liblwgeom < 2.5.0
		skip("snap_to_grid not available in this liblwgeom version")
	y2 = st_snap_to_grid(st_geometry(x), 5000)
	y3 = st_snap_to_grid(st_geometry(x)[[1]], 5000)
	# check that output class match inputs
	expect_is(y1, "sf")
	expect_is(y2, "sfc")
	expect_is(y3, "sfg")
	# check that outputs contain correct number of geometries
	expect_equal(nrow(x), nrow(y1))
	expect_equal(nrow(x), length(y2))
	# check that outputs have correct crs
	expect_equal(st_crs(x), st_crs(y1))
	expect_equal(st_crs(x), st_crs(y2))
	# check that outputs have been snapped correctly, 
	# i.e. the coordinates of the geometries divided by the tolerance (5000)
	# should not yield a remainder
	y1_m <- do.call(rbind, lapply(st_cast(st_geometry(y1), "MULTIPOINT"), as.matrix))
	expect_true(all(c(y1_m %% 5000) == 0))
	y2_m <- do.call(rbind, lapply(st_cast(y2, "MULTIPOINT"), as.matrix))
	expect_true(all(c(y2_m %% 5000) == 0))
	expect_true(all(c(as.matrix(st_cast(y3, "MULTIPOINT")) %% 5000) == 0))
})

test_that("st_transform_proj finds sf's PROJ files", {
  skip_on_os("mac") # FIXME: in sf rather than here
  library(sf)
  nc <- st_read(system.file("gpkg/nc.gpkg", package="sf"), quiet = TRUE)
  bb1 = st_bbox(nc)
  bb2 = st_bbox(st_transform(nc, "+proj=longlat"))
  bb3 = st_bbox(st_transform_proj(nc, "+proj=longlat"))
  bb4 = st_bbox(st_transform_proj(nc, st_crs(4326)$proj4string))
  # expect_false(any(bb1 == bb2))
  # expect_true(all.equal(as.numeric(bb2), as.numeric(bb3)))
  # expect_true(all.equal(as.numeric(bb4), as.numeric(bb3)))
})

test_that("st_linesubstring warns on 4326", {
  library(sf)
  lines = st_sfc(st_linestring(rbind(c(0,0), c(1,2), c(2,0))), crs = 4326)
  library(lwgeom)
  expect_warning(spl <- st_linesubstring(lines, 0.2, 0.8))
  expect_silent(spl <- st_linesubstring(lines[[1]], 0.2, 0.8)) # sfg has no crs
  expect_warning(spl <- st_linesubstring(st_sf(lines), 0.2, 0.8))
  plot(st_geometry(lines), col = 'red', lwd = 3)
  plot(spl, col = 'black', lwd = 3, add = TRUE)
})

test_that("st_startpoint works", {
  library(sf)
  library(lwgeom)
  sp = st_startpoint(st_sfc(st_linestring(matrix(1:10,,2)), st_linestring(matrix(3:12,,2)),crs=4326))
})
