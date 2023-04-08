Chapter 23
================
Dat
2023-04-08

# 23. Model basics

## 23.1 Introduction

Trong model sẽ bao gồm 2 phần cần chú ý:

1.  Family: là dạng của model muốn sử dụng, tuyến tính hay hàm số bậc
    hai, ba
2.  Fitted model: để fit dạng family model muốn sử dụng gần đúng nhất
    với data

Quan trọng nhất là model “tốt nhất” (theo tuỳ chuẩn) không có nghĩa là
model đúng với thực tế “true”

> All models are wrong, but some are useful. - George Box

> For such a model there is no need to ask the question “Is the model
> true?”. If “truth” is to be the “whole truth” the answer must be “No”.
> The only question of interest is “Is the model illuminating and
> useful?”.

Đầu tiên load các libary cần thiết

``` r
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.1     ✔ readr     2.1.4
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ## ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ## ✔ purrr     1.0.1     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

``` r
library(modelr)
options(na.action = na.warn)
```

## 23.2 Model cơ bản

Đầu tiên xem data set của sim1 trong model r, gồm 2 biến x và y ở dạng
continuous

``` r
sim1
```

    ## # A tibble: 30 × 2
    ##        x     y
    ##    <int> <dbl>
    ##  1     1  4.20
    ##  2     1  7.51
    ##  3     1  2.13
    ##  4     2  8.99
    ##  5     2 10.2 
    ##  6     2 11.3 
    ##  7     3  7.36
    ##  8     3 10.5 
    ##  9     3 10.5 
    ## 10     4 12.4 
    ## # ℹ 20 more rows

``` r
ggplot(sim1, aes(x, y)) +
         geom_point()
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Từ plot có thể thấy hai biến x và y có correlation mạnh và ở dạng tuyến
tính, y = a_0 + a_1\*x.

Thử dùng geom_abline để vẽ các đường thẳng với intercept và slope bất kỳ

``` r
models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a1, slope = a2), data = models, alpha = 1/4) +
  geom_point() 
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

=\> Phải tìm giá trị a_0 và a_1 khớp nhất với data.

Sử dụng khoảng cách khác biệt giá trị y dự đoán và giá y trị thực tế để
tìm model thích hợp nhất.

Ví dụ, tính giá trị y dự đoán nếu a_0 = 7 và a_1 =1.5

y = a_0 + a_1 \*x

y = 7 + 1.5 \*x

``` r
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}
model1(c(7, 1.5), sim1) #y = 7 + 1.5 *x 
```

    ##  [1]  8.5  8.5  8.5 10.0 10.0 10.0 11.5 11.5 11.5 13.0 13.0 13.0 14.5 14.5 14.5
    ## [16] 16.0 16.0 16.0 17.5 17.5 17.5 19.0 19.0 19.0 20.5 20.5 20.5 22.0 22.0 22.0

viết function để tính độ lệch

``` r
measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}
measure_distance(c(7, 1.5), sim1)
```

    ## [1] 2.665212

Dùng purrr package để tính căn bậc hai của sai số bình phương cho 250
models

``` r
sim1_dist <- function(a1, a2) {
  measure_distance(c(a1, a2), sim1)
}

models <- models %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models
```

    ## # A tibble: 250 × 3
    ##        a1     a2  dist
    ##     <dbl>  <dbl> <dbl>
    ##  1  -8.63 -0.947  30.7
    ##  2  26.1  -1.40   10.6
    ##  3  21.4  -1.56   10.9
    ##  4 -15.5   2.79   15.9
    ##  5  22.0   4.00   29.1
    ##  6   7.04 -3.34   31.1
    ##  7 -13.5  -4.99   60.0
    ##  8  19.6   2.91   20.4
    ##  9  28.8   1.09   19.6
    ## 10 -11.5  -3.40   48.3
    ## # ℹ 240 more rows

Thử vẽ 10 model với độ lệch nhỏ nhất

``` r
ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(models, rank(dist) <= 10)
  )
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

Ngoài ra còn có thể chuyển giá trị a_1 a_2 vào scatterplot để xem

``` r
ggplot(models, aes(a1, a2)) +
  geom_point(data = filter(models, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist))
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-9-1.png)<!-- -->

Bỏ scatterplot này vào lưới để chọn giá trị a1 và a2 một cách đồng đều
hơn

``` r
grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
  ) %>% 
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>% 
  ggplot(aes(a1, a2)) +
  geom_point(data = filter(grid, rank(dist) <= 10), size = 4, colour = "red") +
  geom_point(aes(colour = -dist)) 
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-10-1.png)<!-- -->

Đem 10 models theo scatter plot này vào lại data

``` r
ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, colour = -dist), 
    data = filter(grid, rank(dist) <= 1)
  )
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-11-1.png)<!-- -->

Nếu làm cho grid càng nhỏ thì cuối cùng ta sẽ có model fit “best”.

Hoặc sử dụng phương pháp Newton-Raphson: chọn một điểm rồi tìm slope dốc
nhất.

``` r
best <- optim(c(0, 0), measure_distance, data = sim1)
best$par
```

    ## [1] 4.222248 2.051204

``` r
ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, colour = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-12-1.png)<!-- -->

Phương pháp này ứng dụng được trên mọi dạng model, nhưng trong model
linear, có function lm để fit model tốt nhất với data

``` r
sim1_mod <- lm(y ~ x, data = sim1)
coef(sim1_mod)
```

    ## (Intercept)           x 
    ##    4.220822    2.051533

### 23.2.1 Exercices

## 23.3 Vẽ model

### 23.3.1 Dự đoán

Tạo data dự đoán

``` r
grid <- sim1 %>%
  data_grid(x)
grid
```

    ## # A tibble: 10 × 1
    ##        x
    ##    <int>
    ##  1     1
    ##  2     2
    ##  3     3
    ##  4     4
    ##  5     5
    ##  6     6
    ##  7     7
    ##  8     8
    ##  9     9
    ## 10    10

Thêm giá trị y dự đoán vào

``` r
sim1
```

    ## # A tibble: 30 × 2
    ##        x     y
    ##    <int> <dbl>
    ##  1     1  4.20
    ##  2     1  7.51
    ##  3     1  2.13
    ##  4     2  8.99
    ##  5     2 10.2 
    ##  6     2 11.3 
    ##  7     3  7.36
    ##  8     3 10.5 
    ##  9     3 10.5 
    ## 10     4 12.4 
    ## # ℹ 20 more rows

``` r
#y = a_1 + a_2 * x
grid <- grid %>% 
  add_predictions(sim1_mod) 
grid
```

    ## # A tibble: 10 × 2
    ##        x  pred
    ##    <int> <dbl>
    ##  1     1  6.27
    ##  2     2  8.32
    ##  3     3 10.4 
    ##  4     4 12.4 
    ##  5     5 14.5 
    ##  6     6 16.5 
    ##  7     7 18.6 
    ##  8     8 20.6 
    ##  9     9 22.7 
    ## 10    10 24.7

Vẽ data dự đoán vào trong plot data quan sát

``` r
ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = pred), data = grid, colour = "red", linewidth = 1)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

### Residuals

Function add_residuals() để thêm giá trị residual vào bảng prediction

``` r
sim1 <- sim1 %>% 
  add_residuals(sim1_mod)
sim1
```

    ## # A tibble: 30 × 3
    ##        x     y    resid
    ##    <int> <dbl>    <dbl>
    ##  1     1  4.20 -2.07   
    ##  2     1  7.51  1.24   
    ##  3     1  2.13 -4.15   
    ##  4     2  8.99  0.665  
    ##  5     2 10.2   1.92   
    ##  6     2 11.3   2.97   
    ##  7     3  7.36 -3.02   
    ##  8     3 10.5   0.130  
    ##  9     3 10.5   0.136  
    ## 10     4 12.4   0.00763
    ## # ℹ 20 more rows

Cách phương pháp vẽ graph cho residual

``` r
ggplot(sim1, aes(resid)) + 
  geom_freqpoly(binwidth = 0.5)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

Hoặc ở dạng scatterplot

``` r
ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0) +
  geom_point() 
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

Scatterplot của resid ở dạng random noise -\> không có bias

``` r
plot(sim1_mod)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->![](Chapter-23_files/figure-gfm/unnamed-chunk-20-2.png)<!-- -->![](Chapter-23_files/figure-gfm/unnamed-chunk-20-3.png)<!-- -->![](Chapter-23_files/figure-gfm/unnamed-chunk-20-4.png)<!-- -->

### 23.3.3 Exercises

Dùng model_matrix() để xem dạng model

``` r
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)
df
```

    ## # A tibble: 2 × 3
    ##       y    x1    x2
    ##   <dbl> <dbl> <dbl>
    ## 1     4     2     5
    ## 2     5     1     6

``` r
model_matrix(df, y ~ x1)
```

    ## # A tibble: 2 × 2
    ##   `(Intercept)`    x1
    ##           <dbl> <dbl>
    ## 1             1     2
    ## 2             1     1

dạng model là: y \~ x1 tương đương với y =

Thêm -1 để bỏ cột intercept mặc định

``` r
model_matrix(df, y ~ x1 - 1)
```

    ## # A tibble: 2 × 1
    ##      x1
    ##   <dbl>
    ## 1     2
    ## 2     1

y = 2 + x

``` r
model_matrix(df, y ~ x1 + x2)
```

    ## # A tibble: 2 × 3
    ##   `(Intercept)`    x1    x2
    ##           <dbl> <dbl> <dbl>
    ## 1             1     2     5
    ## 2             1     1     6

## 23.4 Formulas và model families

Model cơ bản y \~ x viết ở dưới dạng y = a_1 + a_2 \* x

Để xem cách R làm model, dùng function model_matrix

``` r
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)
model_matrix(df, y ~ x1)
```

    ## # A tibble: 2 × 2
    ##   `(Intercept)`    x1
    ##           <dbl> <dbl>
    ## 1             1     2
    ## 2             1     1

R tự động thêm cột intercept vào model với cột đầu chỉ có số 1. Cách để
bỏ cột số một trong model_matrix

``` r
model_matrix(df, y ~ x1 -1 )
```

    ## # A tibble: 2 × 1
    ##      x1
    ##   <dbl>
    ## 1     2
    ## 2     1

``` r
model_matrix(df, y ~ x1 + x2)
```

    ## # A tibble: 2 × 3
    ##   `(Intercept)`    x1    x2
    ##           <dbl> <dbl> <dbl>
    ## 1             1     2     5
    ## 2             1     1     6

### 23.4.1 Dạng categorical

Tạo data frame mẫu và model response phụ thuộc vào giới tính

``` r
df <- tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 2,
  "male", 1
)
model_matrix(df, response ~ sex)
```

    ## # A tibble: 3 × 2
    ##   `(Intercept)` sexmale
    ##           <dbl>   <dbl>
    ## 1             1       1
    ## 2             1       0
    ## 3             1       1

``` r
sim2 %>% head()
```

    ## # A tibble: 6 × 2
    ##   x         y
    ##   <chr> <dbl>
    ## 1 a     1.94 
    ## 2 a     1.18 
    ## 3 a     1.24 
    ## 4 a     2.62 
    ## 5 a     1.11 
    ## 6 a     0.866

ở dạng graph

``` r
ggplot(sim2) +
  geom_point(aes(x, y))
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-29-1.png)<!-- -->

fit model vào

``` r
mod2 <- lm(y ~ x, data = sim2)

grid <- sim2 %>% 
  data_grid(x) %>% 
  add_predictions(mod2)
grid
```

    ## # A tibble: 4 × 2
    ##   x      pred
    ##   <chr> <dbl>
    ## 1 a      1.15
    ## 2 b      8.12
    ## 3 c      6.13
    ## 4 d      1.91

Prediction của y ở mỗi x chính là trung bình của y ở điểm đó

``` r
ggplot(sim2, aes(x)) + 
  geom_point(aes(y = y)) +
  geom_point(data = grid, aes(y = pred), colour = "red", size = 4)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-31-1.png)<!-- -->

### Interaction (continuous and categorical)

Trong trường hợp sim 3 vừa có continuous and categorical

``` r
ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(colour = x2))
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-32-1.png)<!-- -->

2 models có thể fit cho data này

``` r
mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)
```

(y \~ x1 + x2): y = a_0 + a_1\*x1 + a_2\*x2

(y \~ x1 \* x2): y = a_0 + a_1\*x1 + a_2\*x2 +a_12\*x1\*x2

Tạo bảng prediction

``` r
grid <- sim3 %>% 
  data_grid(x1, x2) %>% 
  gather_predictions(mod1, mod2)
grid
```

    ## # A tibble: 80 × 4
    ##    model    x1 x2     pred
    ##    <chr> <int> <fct> <dbl>
    ##  1 mod1      1 a      1.67
    ##  2 mod1      1 b      4.56
    ##  3 mod1      1 c      6.48
    ##  4 mod1      1 d      4.03
    ##  5 mod1      2 a      1.48
    ##  6 mod1      2 b      4.37
    ##  7 mod1      2 c      6.28
    ##  8 mod1      2 d      3.84
    ##  9 mod1      3 a      1.28
    ## 10 mod1      3 b      4.17
    ## # ℹ 70 more rows

Graph

``` r
ggplot(sim3, aes(x1, y, colour = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + 
  facet_wrap(~ model)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-35-1.png)<!-- -->

Xem residual của từng line

``` r
sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-36-1.png)<!-- -->

### Interactions (2 continuous)

``` r
mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)

grid <- sim4 %>% 
  data_grid(
    x1 = seq_range(x1, 5), 
    x2 = seq_range(x2, 5) 
  ) %>% 
  gather_predictions(mod1, mod2)
grid
```

    ## # A tibble: 50 × 4
    ##    model    x1    x2   pred
    ##    <chr> <dbl> <dbl>  <dbl>
    ##  1 mod1   -1    -1    0.996
    ##  2 mod1   -1    -0.5 -0.395
    ##  3 mod1   -1     0   -1.79 
    ##  4 mod1   -1     0.5 -3.18 
    ##  5 mod1   -1     1   -4.57 
    ##  6 mod1   -0.5  -1    1.91 
    ##  7 mod1   -0.5  -0.5  0.516
    ##  8 mod1   -0.5   0   -0.875
    ##  9 mod1   -0.5   0.5 -2.27 
    ## 10 mod1   -0.5   1   -3.66 
    ## # ℹ 40 more rows

Sử dụng seq_range() thay thế cho data_grid(). Thay thế cho việc sử dụng
giá trị unique của x

Sử dụng các argument như

- Ví dụ

  ``` r
  seq_range(c(0.0123, 0.923423), n = 5)
  ```

      ## [1] 0.0123000 0.2400808 0.4678615 0.6956423 0.9234230

- pretty = TRUE

  ``` r
  seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)
  ```

      ## [1] 0.0 0.2 0.4 0.6 0.8 1.0

- trim = 0.1, cắt 10% giá trị đuôi

  ``` r
  x1 <- rcauchy(100)
  print(x1)
  ```

      ##   [1]  -0.16174620  -1.02653617  -0.85385011   1.57680891  -0.02824828
      ##   [6]   0.72217803   0.03376827  12.15238340   1.36769895 -22.30358400
      ##  [11]   1.26887768   1.93774870   4.00752841   0.74811694  -2.26978925
      ##  [16]   9.26706334   0.78264479  -0.39524201   1.50449282  -1.22369048
      ##  [21]  -0.27596411  -0.23369077   0.22150143  -0.54772130  -1.23948094
      ##  [26]  -0.50661334   0.61864872   0.65368298  -0.19525421  -0.26940693
      ##  [31]   0.62985286   0.60797482  -0.89385010   0.55245197   0.19821737
      ##  [36]   0.37968364  23.81793145  -0.09711384  -7.23255819  -0.85591789
      ##  [41]  76.10036395   0.79923928   1.07377890  -3.44768804   1.47452015
      ##  [46]   0.08634594   1.65654107   0.95242556   0.62971915   0.02220374
      ##  [51]  -1.12086118  -1.72834398 -11.23322755   0.66123952   3.00401577
      ##  [56]   0.29352302  -3.37742149  -0.41332516   0.97300524  -3.84799998
      ##  [61]  -0.67564488  -2.01526601   2.03696632  -1.99484125   8.45768672
      ##  [66]   7.47734473  -0.73127668  -1.86256593   0.49019538   1.19930936
      ##  [71]   1.21742748  -0.31395762  -0.81744024   1.32255661  -1.47687524
      ##  [76]   1.85755598   0.65188716  -0.09914464  -0.22014982 157.06434374
      ##  [81]  -0.07296057  -0.19791858  -0.05696744   0.03206905   7.65260001
      ##  [86]   1.36795018  -0.94639565   0.58301839  -7.51655068  -1.40249604
      ##  [91]   4.21681867  -6.11324852   2.91648051   0.40381046   0.64766644
      ##  [96]   4.91135461   0.21646732  -0.70113415  -2.14930654  -0.51356038

  ``` r
  seq_range(x1, n = 5, trim = 0.1)
  ```

      ## [1] -3.9612624 -0.8464079  2.2684466  5.3833011  8.4981555

vẽ

``` r
ggplot(grid, aes(x1, x2)) + 
  geom_tile(aes(fill = pred)) + 
  facet_wrap(~ model)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-41-1.png)<!-- -->

Không thấy rõ model nào fit tốt hơn

``` r
ggplot(grid, aes(x1, pred, colour = x2, group = x2)) + 
  geom_line() +
  facet_wrap(~ model)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-42-1.png)<!-- -->

``` r
ggplot(grid, aes(x2, pred, colour = x1, group = x1)) + 
  geom_line() +
  facet_wrap(~ model)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-42-2.png)<!-- -->

### 23.4.4 Transformations

log(y) \~ sqrt(x1) + x2 biến đổi thành log(y) = a_1 + a_2 \* sqrt(x1) +
a_3 \* x2

Nếu transformation sử dụng dấu +, \*, ^ hay -, ta phải bỏ vào I( )

y \~ x + I(x ^ 2) biến đổi thành y = a_1 + a_2 \* x + a_3 \* x^2

R sẽ tự động bỏ biến dư nếu viết dạng x + x

`y ~ x ^ 2 + x` sẽ thành `y = a_1 + a_2 * x`

``` r
df <- tribble(
  ~y, ~x,
   1,  1,
   2,  2, 
   3,  3
)
model_matrix(df, y ~ x^2 + x)
```

    ## # A tibble: 3 × 2
    ##   `(Intercept)`     x
    ##           <dbl> <dbl>
    ## 1             1     1
    ## 2             1     2
    ## 3             1     3

``` r
model_matrix(df, y ~ I(x^2) + x)
```

    ## # A tibble: 3 × 3
    ##   `(Intercept)` `I(x^2)`     x
    ##           <dbl>    <dbl> <dbl>
    ## 1             1        1     1
    ## 2             1        4     2
    ## 3             1        9     3

Chọn polynomial để smooth tốt

``` r
model_matrix(df, y ~ poly(x, 2))
```

    ## # A tibble: 3 × 3
    ##   `(Intercept)` `poly(x, 2)1` `poly(x, 2)2`
    ##           <dbl>         <dbl>         <dbl>
    ## 1             1     -7.07e- 1         0.408
    ## 2             1     -9.07e-17        -0.816
    ## 3             1      7.07e- 1         0.408

Khi sử dụng poly, ngoài range của data, polynomial sẽ tự động dự đoán
positive and negative infinity. Có sử dụng natural spline

``` r
library(splines)
model_matrix(df, y ~ ns(x, 2))
```

    ## # A tibble: 3 × 3
    ##   `(Intercept)` `ns(x, 2)1` `ns(x, 2)2`
    ##           <dbl>       <dbl>       <dbl>
    ## 1             1       0           0    
    ## 2             1       0.566      -0.211
    ## 3             1       0.344       0.771

``` r
sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)

ggplot(sim5, aes(x, y)) +
  geom_point()
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-47-1.png)<!-- -->

Fit thử 5 loại spline model

``` r
mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)

grid <- sim5 %>% 
  data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>% 
  gather_predictions(mod1, mod2, mod3, mod4, mod5, .pred = "y")

ggplot(sim5, aes(x, y)) + 
  geom_point() +
  geom_line(data = grid, colour = "red") +
  facet_wrap(~ model)
```

![](Chapter-23_files/figure-gfm/unnamed-chunk-48-1.png)<!-- -->

## 23.5 Missing value

``` r
df <- tribble(
  ~x, ~y,
  1, 2.2,
  2, NA,
  3, 3.5,
  4, 8.3,
  NA, 10
)

mod <- lm(y ~ x, data = df)
```

    ## Warning: Dropping 2 rows with missing values

``` r
mod <- lm(y ~ x, data = df, na.action = na.exclude)
```

``` r
nobs(mod)
```

    ## [1] 3
