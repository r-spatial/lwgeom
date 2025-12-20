# Splits input geometries by a vertical line and moves components falling on one side of that line by a fixed amount

Splits input geometries by a vertical line and moves components falling
on one side of that line by a fixed amount

## Usage

``` r
st_wrap_x(x, wrap, move)
```

## Arguments

- x:

  object with geometries to be split

- wrap:

  x value of split line

- move:

  amount by which geometries falling to the left of the line should be
  translated to the right

## Value

object of the same class as `x`

## Examples

``` r
library(sf)
demo(nc, ask = FALSE, echo = FALSE)
x = st_wrap_x(nc, -78, 10)
plot(x[1])
```
