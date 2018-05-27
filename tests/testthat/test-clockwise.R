context("test-clockwise.R")

library(sf)

polys <- st_sf(cw = c(FALSE, TRUE), 
               st_as_sfc(c('POLYGON ((0 0, 1 0, 1 1, 0 0))', 
                           'POLYGON ((1 1, 2 2, 2 1, 1 1))')))

test_that("st_is_polygon_cw works on all classes", {
  expect_equal(c(FALSE, TRUE), st_is_polygon_cw(polys))
  expect_equal(c(FALSE, TRUE), st_is_polygon_cw(st_geometry(polys)))
  expect_false(st_is_polygon_cw(st_geometry(polys)[[1]]))
})

test_that("st_force_polygon_cw works on all classes", {
  
  out_sf <- st_force_polygon_cw(polys)
  out_sfc <- st_force_polygon_cw(st_geometry(polys))
  out_sfg <- st_force_polygon_cw(st_geometry(polys)[[1]])
  
  expect_true(all(st_is_polygon_cw(out_sf)))
  expect_true(all(st_is_polygon_cw(out_sfc)))
  expect_true(all(st_is_polygon_cw(out_sfg)))
})

test_that("st_force_polygon_cw preserves crs", {
  st_crs(polys) <- 4326
  expect_equal(st_crs(st_force_polygon_cw(polys)), 
               st_crs(polys))
  expect_equal(st_crs(st_force_polygon_cw(st_geometry(polys))), 
               st_crs(polys))
})

test_that("st_force_polyfon_cw works with Single polygon, ccw exterior ring only", {
  obj <- st_as_sfc('POLYGON ((0 0, 1 0, 1 1, 0 0))')
  expect_false(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})

test_that("st_force_polyfon_cw works with Single polygon, cw exterior ring only", {
  obj <- st_as_sfc('POLYGON ((0 0, 1 1, 1 0, 0 0))')
  expect_true(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})

test_that("st_force_polyfon_cw works with Single polygon, ccw exterior ring, cw interior rings", {
  obj <- st_as_sfc('POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0), (1 1, 1 2, 2 2, 1 1), (5 5, 5 7, 7 7, 5 5))')
  expect_false(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})

test_that("st_force_polyfon_cw works with Single polygon, cw exterior ring, ccw interior rings", {
  obj <- st_as_sfc('POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0), (1 1, 2 2, 1 2, 1 1), (5 5, 7 7, 5 7, 5 5))')
  expect_true(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})

test_that("st_force_polyfon_cw works with Single polygon, ccw exterior ring, mixed interior rings", {
  obj <- st_as_sfc('POLYGON ((0 0, 10 0, 10 10, 0 10, 0 0), (1 1, 1 2, 2 2, 1 1), (5 5, 7 7, 5 7, 5 5))')
  expect_false(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})

test_that("st_force_polyfon_cw works with Single polygon, cw exterior ring, mixed interior rings", {
  obj <- st_as_sfc('POLYGON ((0 0, 0 10, 10 10, 10 0, 0 0), (1 1, 2 2, 1 2, 1 1), (5 5, 5 7, 7 7, 5 5))')
  expect_false(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})

test_that("st_force_polyfon_cw works with MultiPolygon, ccw exterior rings only", {
  obj <- st_as_sfc('MULTIPOLYGON (((0 0, 1 0, 1 1, 0 0)), ((100 0, 101 0, 101 1, 100 0)))')
  expect_false(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})

test_that("st_force_polyfon_cw works with MultiPolygon, cw exterior rings only", {
  obj <- st_as_sfc('MULTIPOLYGON (((0 0, 1 1, 1 0, 0 0)), ((100 0, 101 1, 101 0, 100 0)))')
  expect_true(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})

test_that("st_force_polyfon_cw works with MultiPolygon, mixed exterior rings", {
  obj <- st_as_sfc('MULTIPOLYGON (((0 0, 1 0, 1 1, 0 0)), ((100 0, 101 1, 101 0, 100 0)))')
  expect_false(st_is_polygon_cw(obj))
  ret <- st_force_polygon_cw(obj)
  expect_true(all(st_is_polygon_cw(ret)))
})
