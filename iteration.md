Iteration
================
2023-03-16

1.  **For loops**

``` r
df <- tibble(
a = rnorm(10),
b = rnorm(10),
c = rnorm(10),
d = rnorm(10)
)
df
```

    ## # A tibble: 10 × 4
    ##          a       b      c      d
    ##      <dbl>   <dbl>  <dbl>  <dbl>
    ##  1 -0.662  -2.56   -1.76   1.08 
    ##  2 -0.0315  0.352   0.640  0.649
    ##  3 -1.49    0.952  -0.690 -0.241
    ##  4  0.727   0.570   0.632  1.38 
    ##  5 -0.908   1.62    0.116 -1.49 
    ##  6  0.966  -0.796  -0.271 -1.75 
    ##  7  2.05   -0.263  -0.941  1.23 
    ##  8 -1.50   -0.765   0.696  0.732
    ##  9  0.511  -0.0355  0.701  0.444
    ## 10  0.549  -0.352   0.567 -0.235

Tính trung vị cho từng cột :

``` r
median(df$a)
```

    ## [1] 0.2399742

``` r
median(df$b)
```

    ## [1] -0.1492868

``` r
median(df$c)
```

    ## [1] 0.34168

``` r
median(df$d)
```

    ## [1] 0.5465563

Tạo 1 vòng lặp để tính trung vị :

``` r
output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output
```

    ## [1]  0.2399742 -0.1492868  0.3416800  0.5465563

``` r
y <- vector("double", 0)
seq_along(y) 
```

    ## integer(0)

``` r
1:length(y)
```

    ## [1] 1 0

**Mỗi vòng lặp for có 3 thành phần :**

-Output

vector(“type”,length) : create an empty vector of given length

“type” : “logical”, “integer”, “double”, “character”, etc

-Sequence : for … in …

-Body : function, gán biến, etc…

**Syntax:**

output \<- ….

for (i in …) {

function

}

output

1.  Compute the mean of every column in `mtcars`.

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
output <- vector("double",ncol(mtcars))
for (i in seq_along(mtcars)) {
  output[[i]] <- mean(mtcars[[i]])
  
}
output
```

    ##  [1]  20.090625   6.187500 230.721875 146.687500   3.596563   3.217250
    ##  [7]  17.848750   0.437500   0.406250   3.687500   2.812500

Determine the type of each column in nycflights13::flights.

``` r
nycflights13::flights
```

    ## # A tibble: 336,776 × 19
    ##     year month   day dep_time sched_de…¹ dep_d…² arr_t…³ sched…⁴ arr_d…⁵ carrier
    ##    <int> <int> <int>    <int>      <int>   <dbl>   <int>   <int>   <dbl> <chr>  
    ##  1  2013     1     1      517        515       2     830     819      11 UA     
    ##  2  2013     1     1      533        529       4     850     830      20 UA     
    ##  3  2013     1     1      542        540       2     923     850      33 AA     
    ##  4  2013     1     1      544        545      -1    1004    1022     -18 B6     
    ##  5  2013     1     1      554        600      -6     812     837     -25 DL     
    ##  6  2013     1     1      554        558      -4     740     728      12 UA     
    ##  7  2013     1     1      555        600      -5     913     854      19 B6     
    ##  8  2013     1     1      557        600      -3     709     723     -14 EV     
    ##  9  2013     1     1      557        600      -3     838     846      -8 B6     
    ## 10  2013     1     1      558        600      -2     753     745       8 AA     
    ## # … with 336,766 more rows, 9 more variables: flight <int>, tailnum <chr>,
    ## #   origin <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>,
    ## #   minute <dbl>, time_hour <dttm>, and abbreviated variable names
    ## #   ¹​sched_dep_time, ²​dep_delay, ³​arr_time, ⁴​sched_arr_time, ⁵​arr_delay

``` r
output <- vector("character",ncol(nycflights13::flights))
for (i in seq_along(nycflights13::flights)) {
  output[[i]] <- typeof(nycflights13::flights[[i]])
}
output
```

    ##  [1] "integer"   "integer"   "integer"   "integer"   "integer"   "double"   
    ##  [7] "integer"   "integer"   "double"    "character" "integer"   "character"
    ## [13] "character" "character" "double"    "double"    "double"    "double"   
    ## [19] "double"

## **2. For loop variations**

There are four variations on the basic theme of the for loop:

1.  Modifying an existing object, instead of creating a new object.

    ``` r
    df <- tibble(
      a = rnorm(10),
      b = rnorm(10),
      c = rnorm(10),
      d = rnorm(10)
    )
    rescale01 <- function(x) {
      rng <- range(x, na.rm = TRUE)
      (x - rng[1]) / (rng[2] - rng[1])
    }

    df$a <- rescale01(df$a)
    df$b <- rescale01(df$b)
    df$c <- rescale01(df$c)
    df$d <- rescale01(df$d)
    ```

1.Output: đã có

2.Sequence : DF = list of columns –\> seq_along(df)

3.Body : function rescale01()

``` r
for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}
```

\[\[ i \]\] : take a single element

2.  Looping patterns (names, values, indices)

    3 basic ways:

    -loop over the numeric indices: for (i in seq_along(xs)) -loop over
    the elements: for (x in xs)

    -loop over the names : for (nm in names(xs))

``` r
results <- vector("list", length(x))
```

    ## Error in vector("list", length(x)): object 'x' not found

``` r
names(results) <- names(x)
```

    ## Error in eval(expr, envir, enclos): object 'x' not found

``` r
for (i in seq_along(x)) {
  name <- names(x)[[i]]
  value <- x[[i]]
}
```

    ## Error in eval(expr, envir, enclos): object 'x' not found

3.  Handling outputs of unknown length.

``` r
means <- c(0, 1, 2)

output <- double()
for (i in seq_along(means)) {
  n <- sample(100, 1)
  output <- c(output, rnorm(n, means[[i]]))
}
str(output)
```

    ##  num [1:154] 0.745 1.221 1.849 -0.322 0.434 ...

``` r
out <- vector("list", length(means))
for (i in seq_along(means)) {
  n <- sample(100, 1)
  out[[i]] <- rnorm(n, means[[i]])
}
str(out)
```

    ## List of 3
    ##  $ : num [1:40] 1.601 -1.284 -0.595 -0.285 -0.934 ...
    ##  $ : num [1:86] 1.884 0.206 3.394 1.206 0.869 ...
    ##  $ : num [1:80] 2.35 2.38 2.67 2.58 2.5 ...

``` r
str(unlist(out))
```

    ##  num [1:206] 1.601 -1.284 -0.595 -0.285 -0.934 ...

purrr::flatten_dbl() : flatten a list of vectors into a single vector

4.  Handling sequences of unknown length.

while (condition) { \#body }

2 thanh phan : condition, body

Co the viet lai vong lap for duoi dang vong lap while nhung khong the
lam nguoc lai

for (i in seq_along(x)) { \# body }

i \<- 1 while (i \<= length(x)) { \# body i \<- i + 1 }

``` r
flip <- function() sample(c("T", "H"), 1)

flips <- 0
nheads <- 0

while (nheads < 3) {
  if (flip() == "H") {
    nheads <- nheads + 1
  } else {
    nheads <- 0
  }
  flips <- flips + 1
}
flips
```

    ## [1] 11

3.  **For loops vs. functionals**

``` r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
```

``` r
output <- vector("double", length(df))
for (i in seq_along(df)) {
  output[[i]] <- mean(df[[i]])
}
output
```

    ## [1] -0.19769468 -0.07351285  0.32319127  0.11238931

``` r
col_mean <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- mean(df[[i]])
  }
  output
}
```

``` r
col_median <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- median(df[[i]])
  }
  output
}
col_sd <- function(df) {
  output <- vector("double", length(df))
  for (i in seq_along(df)) {
    output[i] <- sd(df[[i]])
  }
  output
}
```

f1 \<- function(x) abs(x - mean(x)) ^ 1 f2 \<- function(x) abs(x -
mean(x)) ^ 2 f3 \<- function(x) abs(x - mean(x)) ^ 3

f \<- function(x, i) abs(x - mean(x)) ^ i

``` r
col_summary <- function(df, fun) {
  out <- vector("double", length(df))
  for (i in seq_along(df)) {
    out[i] <- fun(df[[i]])
  }
  out
}
col_summary(df, median)
```

    ## [1] -0.25220831 -0.27344606  0.27591930 -0.03560288

``` r
col_summary(df, mean)
```

    ## [1] -0.19769468 -0.07351285  0.32319127  0.11238931

4.  **The map functions :**

    loi ich : de viet, de doc hon vong for (ko lien quan van de toc do)

map() makes a list. map_lgl() makes a logical vector. map_int() makes an
integer vector. map_dbl() makes a double vector. map_chr() makes a
character vector.

``` r
map_dbl(df, mean)
```

    ##           a           b           c           d 
    ## -0.19769468 -0.07351285  0.32319127  0.11238931

``` r
map_dbl(df, median)
```

    ##           a           b           c           d 
    ## -0.25220831 -0.27344606  0.27591930 -0.03560288

``` r
map_dbl(df, sd)
```

    ##        a        b        c        d 
    ## 0.673410 1.201617 0.904202 1.505946

``` r
df %>% map_dbl(mean)
```

    ##           a           b           c           d 
    ## -0.19769468 -0.07351285  0.32319127  0.11238931

``` r
df %>% map_dbl(median)
```

    ##           a           b           c           d 
    ## -0.25220831 -0.27344606  0.27591930 -0.03560288

``` r
df %>% map_dbl(sd)
```

    ##        a        b        c        d 
    ## 0.673410 1.201617 0.904202 1.505946

differences between map\_\*() and col_summary() : -All purrr functions
are implemented in C. This makes them a little faster at the expense of
readability.

-The second argument, .f, the function to apply, can be a formula, a
character vector, or an integer vector. You’ll learn about those handy
shortcuts in the next section.

-map\_\*() uses … (\[dot dot dot\]) to pass along additional arguments
to .f each time it’s called:

``` r
map_dbl(df, mean, trim = 0.5)
```

    ##           a           b           c           d 
    ## -0.25220831 -0.27344606  0.27591930 -0.03560288

``` r
z <- list(x = 1:3, y = 4:5)
map_int(z, length)
```

    ## x y 
    ## 3 2

Shortcuts

``` r
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(function(df) lm(mpg ~ wt, data = df))
models
```

    ## $`4`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      39.571       -5.647  
    ## 
    ## 
    ## $`6`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##       28.41        -2.78  
    ## 
    ## 
    ## $`8`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = df)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      23.868       -2.192

``` r
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(~lm(mpg ~ wt, data = .))
models
```

    ## $`4`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      39.571       -5.647  
    ## 
    ## 
    ## $`6`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##       28.41        -2.78  
    ## 
    ## 
    ## $`8`
    ## 
    ## Call:
    ## lm(formula = mpg ~ wt, data = .)
    ## 
    ## Coefficients:
    ## (Intercept)           wt  
    ##      23.868       -2.192

``` r
models %>% 
  map(summary) %>% 
  map_dbl(~.$r.squared)
```

    ##         4         6         8 
    ## 0.5086326 0.4645102 0.4229655

``` r
models %>% 
  map(summary) %>% 
  map_dbl("r.squared")
```

    ##         4         6         8 
    ## 0.5086326 0.4645102 0.4229655

``` r
x <- list(list(1, 2, 3), list(4, 5, 6), list(7, 8, 9))
x
```

    ## [[1]]
    ## [[1]][[1]]
    ## [1] 1
    ## 
    ## [[1]][[2]]
    ## [1] 2
    ## 
    ## [[1]][[3]]
    ## [1] 3
    ## 
    ## 
    ## [[2]]
    ## [[2]][[1]]
    ## [1] 4
    ## 
    ## [[2]][[2]]
    ## [1] 5
    ## 
    ## [[2]][[3]]
    ## [1] 6
    ## 
    ## 
    ## [[3]]
    ## [[3]][[1]]
    ## [1] 7
    ## 
    ## [[3]][[2]]
    ## [1] 8
    ## 
    ## [[3]][[3]]
    ## [1] 9

``` r
x %>% map_dbl(2)
```

    ## [1] 2 5 8

Base R

-lapply() : giống với map(), ngoại trừ map() phù hợp với tất cả các chức
năng khác trong purrr và có thể sử dụng phím tắt cho .f. -sapply() : bao
boc xung quanh lappy(), tu dong don gian hoa dau ra nhung ko bao gio
biet minh se nhan dc output gi

``` r
x1 <- list(
  c(0.27, 0.37, 0.57, 0.91, 0.20),
  c(0.90, 0.94, 0.66, 0.63, 0.06), 
  c(0.21, 0.18, 0.69, 0.38, 0.77)
)
x2 <- list(
  c(0.50, 0.72, 0.99, 0.38, 0.78), 
  c(0.93, 0.21, 0.65, 0.13, 0.27), 
  c(0.39, 0.01, 0.38, 0.87, 0.34)
)

threshold <- function(x, cutoff = 0.8) x[x > cutoff]
x1 %>% sapply(threshold) %>% str()
```

    ## List of 3
    ##  $ : num 0.91
    ##  $ : num [1:2] 0.9 0.94
    ##  $ : num(0)

``` r
x2 %>% sapply(threshold) %>% str()
```

    ##  num [1:3] 0.99 0.93 0.87

-vapplpy(df, is.numeric, logical) : giai phap an toan cho sapply(),cung
cap doi so xac dinh type, co the tao ra cac matrice (map() chi tao cac
vector)

5.  **Dealing with failure**

    safely() : nhan vao 1 function va tra ve 1 phien ban da sua doi,
    list cua 2 phan tu: -ket qua ban dau, neu co loi se la NULL -error
    object, neu operation thanh cong thi se la NULL.n

try() : thinh thoang tra ve ket qua ban dau thinh thoang tra ve error
object

``` r
safe_log <- safely(log)
str(safe_log(10))
```

    ## List of 2
    ##  $ result: num 2.3
    ##  $ error : NULL

``` r
str(safe_log("a"))
```

    ## List of 2
    ##  $ result: NULL
    ##  $ error :List of 2
    ##   ..$ message: chr "non-numeric argument to mathematical function"
    ##   ..$ call   : language .Primitive("log")(x, base)
    ##   ..- attr(*, "class")= chr [1:3] "simpleError" "error" "condition"

``` r
x <- list(1, 10, "a")
y <- x %>% map(safely(log))
str(y)
```

    ## List of 3
    ##  $ :List of 2
    ##   ..$ result: num 0
    ##   ..$ error : NULL
    ##  $ :List of 2
    ##   ..$ result: num 2.3
    ##   ..$ error : NULL
    ##  $ :List of 2
    ##   ..$ result: NULL
    ##   ..$ error :List of 2
    ##   .. ..$ message: chr "non-numeric argument to mathematical function"
    ##   .. ..$ call   : language .Primitive("log")(x, base)
    ##   .. ..- attr(*, "class")= chr [1:3] "simpleError" "error" "condition"

purrr::transpose(): tra ve 2 lists : all errors va all outputs

``` r
y <- y %>% transpose()
str(y)
```

    ## List of 2
    ##  $ result:List of 3
    ##   ..$ : num 0
    ##   ..$ : num 2.3
    ##   ..$ : NULL
    ##  $ error :List of 3
    ##   ..$ : NULL
    ##   ..$ : NULL
    ##   ..$ :List of 2
    ##   .. ..$ message: chr "non-numeric argument to mathematical function"
    ##   .. ..$ call   : language .Primitive("log")(x, base)
    ##   .. ..- attr(*, "class")= chr [1:3] "simpleError" "error" "condition"

``` r
y$result[is_ok] %>% flatten_dbl()
```

    ## Error in flatten_dbl(.): object 'is_ok' not found

possibly() : giong ham safely() nhung don gian hon (dua vao gia tri mac
dinh)

``` r
x <- list(1, 10, "a")
x %>% map_dbl(possibly(log, NA_real_))
```

    ## [1] 0.000000 2.302585       NA

quietly() : giong ham safely() nhung thay tra ve error, no tra ve
output, messages va warning

6.  **Mapping over multiple arguments**

map2() , pmap() : iterate multiple related inputs in parallel pmap() :
takes a list of arguments

``` r
mu <- list(5, 10, -3)
mu %>% 
  map(rnorm, n = 5) %>% 
  str()
```

    ## List of 3
    ##  $ : num [1:5] 6.18 4.9 5.62 5.57 4.98
    ##  $ : num [1:5] 10.69 9.14 11.19 11.17 10.78
    ##  $ : num [1:5] -2.8 -2.98 -4.9 -1.83 -2.39

Thay doi do lech chuan

``` r
sigma <- list(1, 5, 10)
seq_along(mu) %>% 
  map(~rnorm(5, mu[[.]], sigma[[.]])) %>% 
  str()
```

    ## List of 3
    ##  $ : num [1:5] 3.89 5.19 6.83 3.82 7.1
    ##  $ : num [1:5] 2.93 5.94 2.78 13.57 11.86
    ##  $ : num [1:5] 13.202 -3.814 -13.423 -0.573 -18.871

``` r
map2(mu, sigma, rnorm, n = 5) %>% str()
```

    ## List of 3
    ##  $ : num [1:5] 3.76 5.98 5.92 5.04 4.14
    ##  $ : num [1:5] 10.95 9.59 10.33 11.28 9.19
    ##  $ : num [1:5] -18.64 -6.79 -12.45 5.39 -14.66

Note that the arguments that vary for each call come before the
function; arguments that are the same for every call come after.

``` r
n <- list(1, 3, 5)
args1 <- list(n, mu, sigma)
args1 %>%
  pmap(rnorm) %>% 
  str()
```

    ## List of 3
    ##  $ : num 5.37
    ##  $ : num [1:3] 9 14.4 6.96
    ##  $ : num [1:5] 4.73 -10.53 2.19 -3.68 12.56

If you don’t name the list’s elements, pmap() will use positional
matching when calling the function.

``` r
args2 <- list(mean = mu, sd = sigma, n = n)
args2 %>% 
  pmap(rnorm) %>% 
  str()
```

    ## List of 3
    ##  $ : num 4.92
    ##  $ : num [1:3] 20.82 8.71 5.56
    ##  $ : num [1:5] -2.28 10.56 -2.38 -3.76 10.83

``` r
params <- tribble(
  ~mean, ~sd, ~n,
    5,     1,  1,
   10,     5,  3,
   -3,    10,  5
)
params %>% 
  pmap(rnorm)
```

    ## [[1]]
    ## [1] 5.442202
    ## 
    ## [[2]]
    ## [1] 12.079921  8.921274  9.683945
    ## 
    ## [[3]]
    ## [1]   0.525594  12.242225  -3.931191  -4.401021 -26.160678

Invoking different functions

``` r
f <- c("runif", "rnorm", "rpois")
param <- list(
  list(min = -1, max = 1), 
  list(sd = 5), 
  list(lambda = 10)
)
```

invoke_map() : list of function, list of giving the arguments, n

``` r
invoke_map(f, param, n = 5) %>% str()
```

    ## Warning: `invoke_map()` was deprecated in purrr 1.0.0.
    ## ℹ Please use map() + exec() instead.

    ## List of 3
    ##  $ : num [1:5] 0.915 -0.777 -0.642 0.308 -0.839
    ##  $ : num [1:5] -5.46 8.5 -4.49 7.53 1.5
    ##  $ : int [1:5] 9 12 9 14 8

``` r
sim <- tribble(
  ~f,      ~params,
  "runif", list(min = -1, max = 1),
  "rnorm", list(sd = 5),
  "rpois", list(lambda = 10)
)
sim %>% 
  mutate(sim = invoke_map(f, params, n = 10))
```

    ## # A tibble: 3 × 3
    ##   f     params           sim       
    ##   <chr> <list>           <list>    
    ## 1 runif <named list [2]> <dbl [10]>
    ## 2 rnorm <named list [1]> <dbl [10]>
    ## 3 rpois <named list [1]> <int [10]>

8.  **Walk** :

    giong ham map(), muon goi 1 ham bi tac dung phu cua no thay vi gia
    tri tra ve cua no Thuong dung de export output ra man hinh hoac save
    ra dia

``` r
x <- list(1, "a", 3)

x %>% 
  walk(print)
```

    ## [1] 1
    ## [1] "a"
    ## [1] 3

walk2() , pwalk() : save each file to the corresponding location on disk
if we have a list of plots and a vector of file names

``` r
library(ggplot2)
plots <- mtcars %>% 
  split(.$cyl) %>% 
  map(~ggplot(., aes(mpg, wt)) + geom_point())
paths <- stringr::str_c(names(plots), ".pdf")

pwalk(list(paths, plots), ggsave, path = tempdir())
```

    ## Saving 7 x 5 in image
    ## Saving 7 x 5 in image
    ## Saving 7 x 5 in image

9.  **Other patterns of for loops**

Predicate functions :return a single TRUE or FALSE keep(), discard() :

``` r
iris %>% 
  keep(is.factor) %>% 
  str()
```

    ## 'data.frame':    150 obs. of  1 variable:
    ##  $ Species: Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...

``` r
iris %>% 
  discard(is.factor) %>% 
  str()
```

    ## 'data.frame':    150 obs. of  4 variables:
    ##  $ Sepal.Length: num  5.1 4.9 4.7 4.6 5 5.4 4.6 5 4.4 4.9 ...
    ##  $ Sepal.Width : num  3.5 3 3.2 3.1 3.6 3.9 3.4 3.4 2.9 3.1 ...
    ##  $ Petal.Length: num  1.4 1.4 1.3 1.5 1.4 1.7 1.4 1.5 1.4 1.5 ...
    ##  $ Petal.Width : num  0.2 0.2 0.2 0.2 0.2 0.4 0.3 0.2 0.2 0.1 ...

some() and every() determine if the predicate is true for any or for all
of the elements.

``` r
x <- list(1:5, letters, list(10))

x %>% 
  some(is_character)
```

    ## [1] TRUE

``` r
x %>% 
  every(is_vector)
```

    ## [1] TRUE

detect() finds the first element where the predicate is true;
detect_index() returns its position.

``` r
x <- sample(10)
x
```

    ##  [1]  4  2  6  8  1  3  5  7  9 10

``` r
x %>% 
  detect(~ . > 5)
```

    ## [1] 6

``` r
x %>% 
  detect_index(~ . > 5)
```

    ## [1] 3

head_while() and tail_while() take elements from the start or end of a
vector while a predicate is true:

``` r
x %>% 
  head_while(~ . > 5)
```

    ## integer(0)

``` r
x %>% 
  tail_while(~ . > 5)
```

    ## [1]  7  9 10

Reduce and accumulate

``` r
#install.packages("purrr")
#library(dplyr)
#library(purrr)
#packageVersion("purrr")
#unloadNamespace("purrr")

dfs <- list(
  age = tibble(name = "John", age = 30),
  sex = tibble(name = c("John", "Mary"), sex = c("M", "F")),
  trt = tibble(name = "Mary", treatment = "A")
)

dfs %>% reduce(full_join)
```

    ## Joining with `by = join_by(name)`
    ## Joining with `by = join_by(name)`

    ## # A tibble: 2 × 4
    ##   name    age sex   treatment
    ##   <chr> <dbl> <chr> <chr>    
    ## 1 John     30 M     <NA>     
    ## 2 Mary     NA F     A

``` r
vs <- list(
  c(1, 3, 5, 6, 10),
  c(1, 2, 3, 7, 8, 10),
  c(1, 2, 3, 4, 8, 9, 10)
)

vs %>% reduce(intersect)
```

    ## [1]  1  3 10

reduce() takes a “binary” function (i.e. a function with two primary
inputs), and applies it repeatedly to a list until there is only a
single element left.

accumulate() is similar but it keeps all the interim results.

``` r
x <- sample(10)
x
```

    ##  [1]  2 10  1  5  9  3  8  6  4  7

``` r
x %>% accumulate(`+`)
```

    ##  [1]  2 12 13 18 27 30 38 44 48 55
