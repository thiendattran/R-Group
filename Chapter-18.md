Chapter 18
================
Dat
2023-03-04

# Chapter 18: Pipe

Load library

``` r
library(magrittr)
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0     ✔ purrr   1.0.1
    ## ✔ tibble  3.1.8     ✔ dplyr   1.1.0
    ## ✔ tidyr   1.3.0     ✔ stringr 1.5.0
    ## ✔ readr   2.1.3     ✔ forcats 1.0.0
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ tidyr::extract()   masks magrittr::extract()
    ## ✖ dplyr::filter()    masks stats::filter()
    ## ✖ dplyr::lag()       masks stats::lag()
    ## ✖ purrr::set_names() masks magrittr::set_names()

Load data diamonds in ggplot2

``` r
diamonds <- ggplot2::diamonds
diamonds2 <- diamonds %>%
  dplyr::mutate(price_per_carat = price/carat)
```

Check RAM sử dụng

``` r
pryr::object_size(diamonds)
```

    ## 3.46 MB

``` r
pryr::object_size(diamonds2)
```

    ## 3.89 MB

``` r
pryr::object_size(diamonds, diamonds2)
```

    ## 3.89 MB

Dung lượng lưu trữ được share giữa 2 object khi dùng pipe

Trường hợp không thể dùng được pipe khi

1.  Function sử dụng “current environment”

``` r
assign("x", 10)
x
```

    ## [1] 10

``` r
"x" %>% assign(100)
x
```

    ## [1] 10

Phải xác nhận environment trước

``` r
env <- environment()
"x" %>% assign(100, envir = env)
x
```

    ## [1] 100

2.  Function sử dụng lazy evaluation

## Khi nào không nên sử dụng pipe

- Nhiều hơn khoảng 10 bước -\> tạo object để dễ debug
- Sử dụng nhiều input

## Các tools khác từ magrittr

### T pipe

``` r
vector<- rnorm(100)
vector %>%
  matrix(ncol=2) %>%
  plot() %>%
  str()
```

![](Chapter-18_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

    ##  NULL

``` r
vector %>%
  matrix(ncol=2) %T>%
  plot() %>%
  str()
```

![](Chapter-18_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

    ##  num [1:50, 1:2] -0.1426 0.0991 -0.7003 -0.2933 0.0329 ...

### \$ pipe

Sử dụng khi function cần dạng API

``` r
mtcars
```

    ##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
    ## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
    ## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
    ## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
    ## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
    ## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
    ## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
    ## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
    ## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
    ## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
    ## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
    ## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
    ## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
    ## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
    ## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
    ## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
    ## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
    ## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
    ## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
    ## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
    ## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
    ## Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
    ## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
    ## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
    ## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
    ## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
    ## Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
    ## Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
    ## Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
    ## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
    ## Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
    ## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
    ## Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2

``` r
mtcars %>%
  cor(disp, mpg)
```

    ## Error in if (is.na(na.method)) stop("invalid 'use' argument"): the condition has length > 1

``` r
cor(mtcars$disp,  mtcars$mpg)
```

    ## [1] -0.8475514

``` r
mtcars %$%
  cor(disp, mpg)
```

    ## [1] -0.8475514

``` r
mtcars <- mtcars %>%
  mutate(cyc_2 = cyl *2 )
mtcars
```

    ##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb cyc_2
    ## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4    12
    ## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4    12
    ## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1     8
    ## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1    12
    ## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2    16
    ## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1    12
    ## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4    16
    ## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2     8
    ## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2     8
    ## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4    12
    ## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4    12
    ## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3    16
    ## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3    16
    ## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3    16
    ## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4    16
    ## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4    16
    ## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4    16
    ## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1     8
    ## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2     8
    ## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1     8
    ## Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1     8
    ## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2    16
    ## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2    16
    ## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4    16
    ## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2    16
    ## Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1     8
    ## Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2     8
    ## Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2     8
    ## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4    16
    ## Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6    12
    ## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8    16
    ## Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2     8

``` r
mtcars %<>% mutate(cyc_2 = cyl * 2)
mtcars
```

    ##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb cyc_2
    ## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4    12
    ## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4    12
    ## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1     8
    ## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1    12
    ## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2    16
    ## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1    12
    ## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4    16
    ## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2     8
    ## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2     8
    ## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4    12
    ## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4    12
    ## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3    16
    ## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3    16
    ## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3    16
    ## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4    16
    ## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4    16
    ## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4    16
    ## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1     8
    ## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2     8
    ## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1     8
    ## Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1     8
    ## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2    16
    ## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2    16
    ## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4    16
    ## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2    16
    ## Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1     8
    ## Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2     8
    ## Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2     8
    ## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4    16
    ## Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6    12
    ## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8    16
    ## Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2     8
