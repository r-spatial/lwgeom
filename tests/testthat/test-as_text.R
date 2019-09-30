context("test-as_text.R")
library(sf)

test_that("Prints Points", {
  pt <- st_sfc(st_point(c(1.0002,2.3030303)), crs = 4326)
  expect_equal(st_asewkt(pt, 1), "SRID=4326;POINT(1 2.3)")
  expect_equal(st_astext(pt, 2, EWKT = FALSE), "POINT(1 2.3)")
  expect_equal(st_astext(pt, 3, EWKT = FALSE), "POINT(1 2.303)")
  expect_equal(st_astext(pt, 10, EWKT = FALSE), "POINT(1.0002 2.3030303)")
})

test_that("Prints Polygons and Lines", {
  pol <- st_sfc(st_polygon(list(
    rbind(c(0,0),c(0.5,0),c(0.5,0.5),c(0.5,0),c(1,0),c(1,1),c(0,1),c(0,0))
    )))
  txt <- "POLYGON((0 0,0.5 0,0.5 0.5,0.5 0,1 0,1 1,0 1,0 0))"
  expect_equal(st_astext(pol), txt)
  ln <- st_cast(pol, "LINESTRING")
  txt <- "LINESTRING(0 0,0.5 0,0.5 0.5,0.5 0,1 0,1 1,0 1,0 0)"
  expect_equal(st_astext(ln), txt)
})
