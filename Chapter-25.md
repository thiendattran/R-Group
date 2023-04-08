Chapter 25
================
Dat
2023-04-08

## 25 Many models

## 25.1 Giới thiệu

Chapter này sẽ đưa ra 3 ý tưởng để có thể sử dụng nhiều model cùng lúc
với nhau một cách dễ dàng:

1.  Sử dùng nhiều model nhỏ để hiểu các datasets phức tạp
2.  Sử dụng list-column để chưa cái dạng data ngẫu nhiên trong dataset,
    ví dụ như một cột để chứa model linear
3.  Sử dụng brooom package by David Robinson, để biến model thành dạng
    tidy.

### Library cần thiết

``` r
library(modelr)
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
library(gapminder)
```

## 25.2 Gapminder

Data được sử dụng từ Hans Rosling, bác sĩ và nhà thống kê người thuỵ
Điện

``` r
gapminder
```

    ## # A tibble: 1,704 × 6
    ##    country     continent  year lifeExp      pop gdpPercap
    ##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
    ##  1 Afghanistan Asia       1952    28.8  8425333      779.
    ##  2 Afghanistan Asia       1957    30.3  9240934      821.
    ##  3 Afghanistan Asia       1962    32.0 10267083      853.
    ##  4 Afghanistan Asia       1967    34.0 11537966      836.
    ##  5 Afghanistan Asia       1972    36.1 13079460      740.
    ##  6 Afghanistan Asia       1977    38.4 14880372      786.
    ##  7 Afghanistan Asia       1982    39.9 12881816      978.
    ##  8 Afghanistan Asia       1987    40.8 13867957      852.
    ##  9 Afghanistan Asia       1992    41.7 16317921      649.
    ## 10 Afghanistan Asia       1997    41.8 22227415      635.
    ## # ℹ 1,694 more rows

Để trả lời câu hỏi “tuổi thọ trung bình(life expectancy) có thay đổi
theo thời gian (year) hay không cho từng quốc gia?”, đầu tiên kiểm tra
data dưới dạng plot

``` r
gapminder %>%
  ggplot(aes(year, lifeExp, group = country)) +
  geom_line(alpha = 1/3)
```

![](Chapter-25_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

Data chỉ có khoảng 1700 observations và 3 biến nhưng cũng khó có thể
hiểu được trên plot nảy. Nhưng nhìn chung tất cả nước đều có tuổi thọ
trung bình tăng. Tuy nhiên có 1 vài quốc gia không đi theo trend này,
làm sao để thấy được các quốc gia này rõ hơn?

Sử dụng phương pháp như tỏng chapter 24. Tách phần trend tăng lên bình
thường ra khỏi model và đánh giá dựa trên residuals.

Cách làm như chapter 24 đối với 1 nước

``` r
nz <- filter (gapminder, country == "New Zealand")
nz %>%
  ggplot(aes(year,lifeExp)) +
  geom_line() +
  ggtitle("Full data = ")
```

![](Chapter-25_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
nz_mod <- lm(lifeExp ~ year , data = nz)
nz %>%
  add_predictions(nz_mod) %>%
  ggplot(aes(year,pred)) +
  geom_line() +
  ggtitle("Linear trend + ")
```

![](Chapter-25_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

``` r
nz %>% add_residuals(nz_mod) %>%
  ggplot(aes(year, resid)) +
  geom_hline(yintercept = 0, color = "white", size = 3) +
  geom_line() +
  ggtitle("Remaining pattern")
```

    ## Warning: Using `size` aesthetic for lines was deprecated in ggplot2 3.4.0.
    ## ℹ Please use `linewidth` instead.
    ## This warning is displayed once every 8 hours.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

![](Chapter-25_files/figure-gfm/unnamed-chunk-4-3.png)<!-- -->

Cách làm tương tự với từng nước khác nhau như thế nào?

### 25.2.1 Nested data

Trong trường hợp này khó có thể sử dụng map function từ purr. Chúng ta
cần dạng data mới ở dạng nested dataframe

``` r
by_country <- gapminder %>%
  group_by(country, continent) %>%
  nest()

by_country
```

    ## # A tibble: 142 × 3
    ## # Groups:   country, continent [142]
    ##    country     continent data             
    ##    <fct>       <fct>     <list>           
    ##  1 Afghanistan Asia      <tibble [12 × 4]>
    ##  2 Albania     Europe    <tibble [12 × 4]>
    ##  3 Algeria     Africa    <tibble [12 × 4]>
    ##  4 Angola      Africa    <tibble [12 × 4]>
    ##  5 Argentina   Americas  <tibble [12 × 4]>
    ##  6 Australia   Oceania   <tibble [12 × 4]>
    ##  7 Austria     Europe    <tibble [12 × 4]>
    ##  8 Bahrain     Asia      <tibble [12 × 4]>
    ##  9 Bangladesh  Asia      <tibble [12 × 4]>
    ## 10 Belgium     Europe    <tibble [12 × 4]>
    ## # ℹ 132 more rows

Chúng ta tạo được data frame ở dạng nested, cột data chưa dataframe nhỏ
của từng quốc gia khác nhau. Cách để xem data trong từng quốc gia khác
nhau ở dạng nested dataframe

``` r
by_country$data[[1]]
```

    ## # A tibble: 12 × 4
    ##     year lifeExp      pop gdpPercap
    ##    <int>   <dbl>    <int>     <dbl>
    ##  1  1952    28.8  8425333      779.
    ##  2  1957    30.3  9240934      821.
    ##  3  1962    32.0 10267083      853.
    ##  4  1967    34.0 11537966      836.
    ##  5  1972    36.1 13079460      740.
    ##  6  1977    38.4 14880372      786.
    ##  7  1982    39.9 12881816      978.
    ##  8  1987    40.8 13867957      852.
    ##  9  1992    41.7 16317921      649.
    ## 10  1997    41.8 22227415      635.
    ## 11  2002    42.1 25268405      727.
    ## 12  2007    43.8 31889923      975.

### 25.2.2 List-column

Cách để tạo model cho từng quốc gia khác nhau. Ta có dạng model cơ bản ở
dạng

``` r
country_model <- function(df) {
  lm(lifeExp ~ year, data = df)
}
```

Chúng ta có thể sử dụng purrr:map() để apply country_model cho từng
element

``` r
models <- map(by_country$data, country_model)
```

Đưa models này thành một cột khác trong tibble

``` r
by_country <- by_country %>%
   mutate(model = map(data, country_model))
by_country
```

    ## # A tibble: 142 × 4
    ## # Groups:   country, continent [142]
    ##    country     continent data              model 
    ##    <fct>       <fct>     <list>            <list>
    ##  1 Afghanistan Asia      <tibble [12 × 4]> <lm>  
    ##  2 Albania     Europe    <tibble [12 × 4]> <lm>  
    ##  3 Algeria     Africa    <tibble [12 × 4]> <lm>  
    ##  4 Angola      Africa    <tibble [12 × 4]> <lm>  
    ##  5 Argentina   Americas  <tibble [12 × 4]> <lm>  
    ##  6 Australia   Oceania   <tibble [12 × 4]> <lm>  
    ##  7 Austria     Europe    <tibble [12 × 4]> <lm>  
    ##  8 Bahrain     Asia      <tibble [12 × 4]> <lm>  
    ##  9 Bangladesh  Asia      <tibble [12 × 4]> <lm>  
    ## 10 Belgium     Europe    <tibble [12 × 4]> <lm>  
    ## # ℹ 132 more rows

Cách làm này để chúng ta có thể chứa tất cả mọi biến và model liên quan
vào chung chùng một bảng. Trong trường hợp ta chỉ cần model của châu Âu

``` r
by_country %>%
  filter(continent == "Europe")
```

    ## # A tibble: 30 × 4
    ## # Groups:   country, continent [30]
    ##    country                continent data              model 
    ##    <fct>                  <fct>     <list>            <list>
    ##  1 Albania                Europe    <tibble [12 × 4]> <lm>  
    ##  2 Austria                Europe    <tibble [12 × 4]> <lm>  
    ##  3 Belgium                Europe    <tibble [12 × 4]> <lm>  
    ##  4 Bosnia and Herzegovina Europe    <tibble [12 × 4]> <lm>  
    ##  5 Bulgaria               Europe    <tibble [12 × 4]> <lm>  
    ##  6 Croatia                Europe    <tibble [12 × 4]> <lm>  
    ##  7 Czech Republic         Europe    <tibble [12 × 4]> <lm>  
    ##  8 Denmark                Europe    <tibble [12 × 4]> <lm>  
    ##  9 Finland                Europe    <tibble [12 × 4]> <lm>  
    ## 10 France                 Europe    <tibble [12 × 4]> <lm>  
    ## # ℹ 20 more rows

### 25.2.3 Unnesting

Từ data 142 nước chúng ta đã có 142 model khác nhau theo từng quốc gia
chung 1 bảng dataframe. Làm tượn tự để thêm cột residuals vào từng
model-data

``` r
by_country <- by_country %>%
  mutate(
    resids = map2(data, model, add_residuals)
  )
by_country
```

    ## # A tibble: 142 × 5
    ## # Groups:   country, continent [142]
    ##    country     continent data              model  resids           
    ##    <fct>       <fct>     <list>            <list> <list>           
    ##  1 Afghanistan Asia      <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ##  2 Albania     Europe    <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ##  3 Algeria     Africa    <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ##  4 Angola      Africa    <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ##  5 Argentina   Americas  <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ##  6 Australia   Oceania   <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ##  7 Austria     Europe    <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ##  8 Bahrain     Asia      <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ##  9 Bangladesh  Asia      <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ## 10 Belgium     Europe    <tibble [12 × 4]> <lm>   <tibble [12 × 5]>
    ## # ℹ 132 more rows

Xem data residual bằng cách unnest

``` r
resids <- unnest(by_country, resids)
resids
```

    ## # A tibble: 1,704 × 9
    ## # Groups:   country, continent [142]
    ##    country     continent data     model   year lifeExp     pop gdpPercap   resid
    ##    <fct>       <fct>     <list>   <list> <int>   <dbl>   <int>     <dbl>   <dbl>
    ##  1 Afghanistan Asia      <tibble> <lm>    1952    28.8  8.43e6      779. -1.11  
    ##  2 Afghanistan Asia      <tibble> <lm>    1957    30.3  9.24e6      821. -0.952 
    ##  3 Afghanistan Asia      <tibble> <lm>    1962    32.0  1.03e7      853. -0.664 
    ##  4 Afghanistan Asia      <tibble> <lm>    1967    34.0  1.15e7      836. -0.0172
    ##  5 Afghanistan Asia      <tibble> <lm>    1972    36.1  1.31e7      740.  0.674 
    ##  6 Afghanistan Asia      <tibble> <lm>    1977    38.4  1.49e7      786.  1.65  
    ##  7 Afghanistan Asia      <tibble> <lm>    1982    39.9  1.29e7      978.  1.69  
    ##  8 Afghanistan Asia      <tibble> <lm>    1987    40.8  1.39e7      852.  1.28  
    ##  9 Afghanistan Asia      <tibble> <lm>    1992    41.7  1.63e7      649.  0.754 
    ## 10 Afghanistan Asia      <tibble> <lm>    1997    41.8  2.22e7      635. -0.534 
    ## # ℹ 1,694 more rows

Sau khi đã có residual cho từng quốc gia, ta có thể plot dưới dạng

``` r
resids %>% 
  ggplot(aes(year, resid)) +
    geom_line(aes(group = country), alpha = 1 / 3) + 
    geom_smooth(se = FALSE)
```

    ## `geom_smooth()` using method = 'gam' and formula = 'y ~ s(x, bs = "cs")'

![](Chapter-25_files/figure-gfm/unnamed-chunk-13-1.png)<!-- -->

Chia theo subgroup từng lục địa

``` r
resids %>% 
  ggplot(aes(year, resid)) +
    geom_line(aes(group = country), alpha = 1 / 3) + 
    geom_smooth(se = FALSE)+
  facet_wrap(~continent)
```

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](Chapter-25_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

Model từ Africa vẫn còn patterns để có thể fit vào model

### 25.2.4 Chất lượng model (quality)

Ngoài cách nhìn residual, còn một số cách khác để đánh giá model. Sử
dụng package broom::glance để xem thêm các chỉ số logLik, AIC, BIC,
deviance

``` r
broom::glance(nz_mod)
```

    ## # A tibble: 1 × 12
    ##   r.squared adj.r.squared sigma statistic      p.value    df logLik   AIC   BIC
    ##       <dbl>         <dbl> <dbl>     <dbl>        <dbl> <dbl>  <dbl> <dbl> <dbl>
    ## 1     0.954         0.949 0.804      205. 0.0000000541     1  -13.3  32.6  34.1
    ## # ℹ 3 more variables: deviance <dbl>, df.residual <int>, nobs <int>

Lặp lại cho 142 model

``` r
by_country %>%
  mutate(glance = map(model, broom::glance)) %>%
  unnest(glance)
```

    ## # A tibble: 142 × 17
    ## # Groups:   country, continent [142]
    ##    country     continent data     model  resids   r.squared adj.r.squared sigma
    ##    <fct>       <fct>     <list>   <list> <list>       <dbl>         <dbl> <dbl>
    ##  1 Afghanistan Asia      <tibble> <lm>   <tibble>     0.948         0.942 1.22 
    ##  2 Albania     Europe    <tibble> <lm>   <tibble>     0.911         0.902 1.98 
    ##  3 Algeria     Africa    <tibble> <lm>   <tibble>     0.985         0.984 1.32 
    ##  4 Angola      Africa    <tibble> <lm>   <tibble>     0.888         0.877 1.41 
    ##  5 Argentina   Americas  <tibble> <lm>   <tibble>     0.996         0.995 0.292
    ##  6 Australia   Oceania   <tibble> <lm>   <tibble>     0.980         0.978 0.621
    ##  7 Austria     Europe    <tibble> <lm>   <tibble>     0.992         0.991 0.407
    ##  8 Bahrain     Asia      <tibble> <lm>   <tibble>     0.967         0.963 1.64 
    ##  9 Bangladesh  Asia      <tibble> <lm>   <tibble>     0.989         0.988 0.977
    ## 10 Belgium     Europe    <tibble> <lm>   <tibble>     0.995         0.994 0.293
    ## # ℹ 132 more rows
    ## # ℹ 9 more variables: statistic <dbl>, p.value <dbl>, df <dbl>, logLik <dbl>,
    ## #   AIC <dbl>, BIC <dbl>, deviance <dbl>, df.residual <int>, nobs <int>

Vẫn còn chứa cột data ở dạng list, vì lý do function unnest()

``` r
glance <- by_country %>% 
  mutate(glance = map(model, broom::glance)) %>% 
  unnest(glance, .drop = TRUE)
```

    ## Warning: The `.drop` argument of `unnest()` is deprecated as of tidyr 1.0.0.
    ## ℹ All list-columns are now preserved.
    ## Call `lifecycle::last_lifecycle_warnings()` to see where this warning was
    ## generated.

Deprecated function already

Xem các model theo thứ tự rsquare

``` r
glance %>% 
  arrange(r.squared)
```

    ## # A tibble: 142 × 17
    ## # Groups:   country, continent [142]
    ##    country       continent data     model resids   r.squared adj.r.squared sigma
    ##    <fct>         <fct>     <list>   <lis> <list>       <dbl>         <dbl> <dbl>
    ##  1 Rwanda        Africa    <tibble> <lm>  <tibble>    0.0172      -0.0811   6.56
    ##  2 Botswana      Africa    <tibble> <lm>  <tibble>    0.0340      -0.0626   6.11
    ##  3 Zimbabwe      Africa    <tibble> <lm>  <tibble>    0.0562      -0.0381   7.21
    ##  4 Zambia        Africa    <tibble> <lm>  <tibble>    0.0598      -0.0342   4.53
    ##  5 Swaziland     Africa    <tibble> <lm>  <tibble>    0.0682      -0.0250   6.64
    ##  6 Lesotho       Africa    <tibble> <lm>  <tibble>    0.0849      -0.00666  5.93
    ##  7 Cote d'Ivoire Africa    <tibble> <lm>  <tibble>    0.283        0.212    3.93
    ##  8 South Africa  Africa    <tibble> <lm>  <tibble>    0.312        0.244    4.74
    ##  9 Uganda        Africa    <tibble> <lm>  <tibble>    0.342        0.276    3.19
    ## 10 Congo, Dem. … Africa    <tibble> <lm>  <tibble>    0.348        0.283    2.43
    ## # ℹ 132 more rows
    ## # ℹ 9 more variables: statistic <dbl>, p.value <dbl>, df <dbl>, logLik <dbl>,
    ## #   AIC <dbl>, BIC <dbl>, deviance <dbl>, df.residual <int>, nobs <int>

Các model tệ nhất ở Châu Phi,

``` r
glance %>% 
  ggplot(aes(continent, r.squared)) + 
    geom_jitter(width = 0.5)
```

![](Chapter-25_files/figure-gfm/unnamed-chunk-19-1.png)<!-- -->

thấy xem model của những đất nước có residual nhỏ

``` r
bad_fit <- filter (glance, r.squared < 0.25)

gapminder %>% 
  semi_join(bad_fit, by = "country") %>% 
  ggplot(aes(year, lifeExp, colour = country)) +
    geom_line()
```

![](Chapter-25_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

Thấy được ảnh hưởng ủa HIV/AIDS và diệt chủng ở Rwanda

## 25.3 List-column

Cách sử dụng list-column trong R. Base R có nhiều function làm khó trong
việc sử dụng list column. Ví dụ muốn tạo cột ở dạng

| X           |
|-------------|
| list(1,2,3) |
| list(3,4,5) |
|             |

``` r
data.frame(x = list(1:3, 3:5)
)
```

    ##   x.1.3 x.3.5
    ## 1     1     3
    ## 2     2     4
    ## 3     3     5

Để tránh data.frame() tự đưa list về bảng ta cần dùng dấu I()

``` r
data.frame(
  x = I(list(1:3, 3:5)),
  y = c("1, 2", "3, 4 ,5")
)
```

    ##         x       y
    ## 1 1, 2, 3    1, 2
    ## 2 3, 4, 5 3, 4 ,5

Ở dạng tibble

``` r
tibble(
  x = list(1:3, 3:5),
  y = c("1, 2", "3, 5, 5")
)
```

    ## # A tibble: 2 × 2
    ##   x         y      
    ##   <list>    <chr>  
    ## 1 <int [3]> 1, 2   
    ## 2 <int [3]> 3, 5, 5

dễ hơn nếu sử dụng tribble

``` r
tribble(
   ~x, ~y,
  1:3, "1, 2",
  3:5, "3, 4, 5"
)
```

    ## # A tibble: 2 × 2
    ##   x         y      
    ##   <list>    <chr>  
    ## 1 <int [3]> 1, 2   
    ## 2 <int [3]> 3, 4, 5

## 25.4 Tạo list column

Thường chúng ta sẽ tạo list column từ column thường, sử dụng 1 trong 3
phương pháp:

1.  tidyr::nest
2.  mutate
3.  summerise

Generally, cần phải chắc là list column phải cùng dạng homogenous cho
mỗi dòng.

### 25.4.1 Sử dụng nesting

nest tạo nested dataframe. mỗi nested data frame là một meta
observation. Các cột khác sẽ là cột giá trị variables khác của meta
observation đó.

``` r
gapminder %>%
  group_by(country, continent) %>%
  nest()
```

    ## # A tibble: 142 × 3
    ## # Groups:   country, continent [142]
    ##    country     continent data             
    ##    <fct>       <fct>     <list>           
    ##  1 Afghanistan Asia      <tibble [12 × 4]>
    ##  2 Albania     Europe    <tibble [12 × 4]>
    ##  3 Algeria     Africa    <tibble [12 × 4]>
    ##  4 Angola      Africa    <tibble [12 × 4]>
    ##  5 Argentina   Americas  <tibble [12 × 4]>
    ##  6 Australia   Oceania   <tibble [12 × 4]>
    ##  7 Austria     Europe    <tibble [12 × 4]>
    ##  8 Bahrain     Asia      <tibble [12 × 4]>
    ##  9 Bangladesh  Asia      <tibble [12 × 4]>
    ## 10 Belgium     Europe    <tibble [12 × 4]>
    ## # ℹ 132 more rows

Ngoài ra còn có thể sự dụng trên ungroup data, nếu viết các cột cần
group lại với nhau ra

``` r
gapminder %>%
  nest(data = c(year:gdpPercap))
```

    ## # A tibble: 142 × 3
    ##    country     continent data             
    ##    <fct>       <fct>     <list>           
    ##  1 Afghanistan Asia      <tibble [12 × 4]>
    ##  2 Albania     Europe    <tibble [12 × 4]>
    ##  3 Algeria     Africa    <tibble [12 × 4]>
    ##  4 Angola      Africa    <tibble [12 × 4]>
    ##  5 Argentina   Americas  <tibble [12 × 4]>
    ##  6 Australia   Oceania   <tibble [12 × 4]>
    ##  7 Austria     Europe    <tibble [12 × 4]>
    ##  8 Bahrain     Asia      <tibble [12 × 4]>
    ##  9 Bangladesh  Asia      <tibble [12 × 4]>
    ## 10 Belgium     Europe    <tibble [12 × 4]>
    ## # ℹ 132 more rows

### 25.4.2 Từ vectorize function

``` r
df <- tribble(
  ~x1,
  "a,b,c", 
  "d,e,f,g"
) 

df %>% 
  mutate(x2 = stringr::str_split(x1, ","))
```

    ## # A tibble: 2 × 2
    ##   x1      x2       
    ##   <chr>   <list>   
    ## 1 a,b,c   <chr [3]>
    ## 2 d,e,f,g <chr [4]>

``` r
df %>% 
  mutate(x2 = stringr::str_split(x1, ",")) %>% 
  unnest(x2)
```

    ## # A tibble: 7 × 2
    ##   x1      x2   
    ##   <chr>   <chr>
    ## 1 a,b,c   a    
    ## 2 a,b,c   b    
    ## 3 a,b,c   c    
    ## 4 d,e,f,g d    
    ## 5 d,e,f,g e    
    ## 6 d,e,f,g f    
    ## 7 d,e,f,g g

và các function vectorize khác như map(), map2(), pmap() từ purrr

``` r
sim <- tribble(
  ~f,      ~params,
  "runif", list(min = -1, max = 1),
  "rnorm", list(sd = 5),
  "rpois", list(lambda = 10)
)
sim
```

    ## # A tibble: 3 × 2
    ##   f     params          
    ##   <chr> <list>          
    ## 1 runif <named list [2]>
    ## 2 rnorm <named list [1]>
    ## 3 rpois <named list [1]>

``` r
sim %>%
  mutate(sims = invoke_map(f, params, n = 10))
```

    ## Warning: There was 1 warning in `mutate()`.
    ## ℹ In argument: `sims = invoke_map(f, params, n = 10)`.
    ## Caused by warning:
    ## ! `invoke_map()` was deprecated in purrr 1.0.0.
    ## ℹ Please use map() + exec() instead.

    ## # A tibble: 3 × 3
    ##   f     params           sims      
    ##   <chr> <list>           <list>    
    ## 1 runif <named list [2]> <dbl [10]>
    ## 2 rnorm <named list [1]> <dbl [10]>
    ## 3 rpois <named list [1]> <int [10]>

``` r
#invoke_map is deprecated
```

### 25.4.3 Tạo nest từ summaries\* (

summarise đã bị xoá và cần đổi về sử dụng rẻame

``` r
mtcars %>%
  group_by(cyl) %>%
  reframe(q = quantile(mpg))
```

    ## # A tibble: 15 × 2
    ##      cyl     q
    ##    <dbl> <dbl>
    ##  1     4  21.4
    ##  2     4  22.8
    ##  3     4  26  
    ##  4     4  30.4
    ##  5     4  33.9
    ##  6     6  17.8
    ##  7     6  18.6
    ##  8     6  19.7
    ##  9     6  21  
    ## 10     6  21.4
    ## 11     8  10.4
    ## 12     8  14.4
    ## 13     8  15.2
    ## 14     8  16.2
    ## 15     8  19.2

``` r
mtcars %>% 
  group_by(cyl) %>% 
  reframe(q = list(quantile(mpg)))
```

    ## # A tibble: 3 × 2
    ##     cyl q        
    ##   <dbl> <list>   
    ## 1     4 <dbl [5]>
    ## 2     6 <dbl [5]>
    ## 3     8 <dbl [5]>

``` r
probs <- c(0.01, 0.25, 0.5, 0.75, 0.99)
mtcars %>% 
  group_by(cyl) %>% 
  reframe(p = list(probs), q = list(quantile(mpg, probs))) %>% 
  unnest(c(p, q))
```

    ## # A tibble: 15 × 3
    ##      cyl     p     q
    ##    <dbl> <dbl> <dbl>
    ##  1     4  0.01  21.4
    ##  2     4  0.25  22.8
    ##  3     4  0.5   26  
    ##  4     4  0.75  30.4
    ##  5     4  0.99  33.8
    ##  6     6  0.01  17.8
    ##  7     6  0.25  18.6
    ##  8     6  0.5   19.7
    ##  9     6  0.75  21  
    ## 10     6  0.99  21.4
    ## 11     8  0.01  10.4
    ## 12     8  0.25  14.4
    ## 13     8  0.5   15.2
    ## 14     8  0.75  16.2
    ## 15     8  0.99  19.1

### 25.4.4 Từ named list

``` r
x <- list(
  a = 1:5,
  b = 3:4, 
  c = 5:6
) 

df <- enframe(x)
df
```

    ## # A tibble: 3 × 2
    ##   name  value    
    ##   <chr> <list>   
    ## 1 a     <int [5]>
    ## 2 b     <int [2]>
    ## 3 c     <int [2]>

Để sử dụng dữ liệu trong cột name và list-column ta dùng map2 function

``` r
df %>%
  mutate(
    smry = map2_chr(name, value, ~ stringr::str_c(.x,": ", .y[1]))
  )
```

    ## # A tibble: 3 × 3
    ##   name  value     smry 
    ##   <chr> <list>    <chr>
    ## 1 a     <int [5]> a: 1 
    ## 2 b     <int [2]> b: 3 
    ## 3 c     <int [2]> c: 5

``` r
df %>%
  unnest()
```

    ## Warning: `cols` is now required when using `unnest()`.
    ## ℹ Please use `cols = c(value)`.

    ## # A tibble: 9 × 2
    ##   name  value
    ##   <chr> <int>
    ## 1 a         1
    ## 2 a         2
    ## 3 a         3
    ## 4 a         4
    ## 5 a         5
    ## 6 b         3
    ## 7 b         4
    ## 8 c         5
    ## 9 c         6

## 25.5 Đơn giản hoá list-column

Để sử dụng được các function khác, phải đơn giản hoá list-column thành
column bình thường

1.  Nếu cần sử dụng 1 biến trong column-list, sử dụng mutate và map
2.  Nếu cần sử dụng nhiều biến, nên sử dụng unnest

### 25.5.1 List thành vector

``` r
df <- tribble(
  ~x,
  letters[1:5],
  1:3,
  runif(5)
)
  
df %>% mutate(
  type = map_chr(x, typeof),
  length = map_int(x, length)
)
```

    ## # A tibble: 3 × 3
    ##   x         type      length
    ##   <list>    <chr>      <int>
    ## 1 <chr [5]> character      5
    ## 2 <int [3]> integer        3
    ## 3 <dbl [5]> double         5

``` r
df <- tribble(
  ~x,
  list(a = 1, b = 2),
  list(a = 2, c = 4)
)
df %>% mutate(
  a = map_dbl(x, "a"),
  b = map_dbl(x, "b", .null = NA_real_)
)
```

    ## # A tibble: 2 × 3
    ##   x                    a     b
    ##   <list>           <dbl> <dbl>
    ## 1 <named list [2]>     1     2
    ## 2 <named list [2]>     2    NA

### 25.5.2 Unnesting

``` r
tibble(x = 1:2, y = list(1:4,1)) %>% unnest(y)
```

    ## # A tibble: 5 × 2
    ##       x     y
    ##   <int> <dbl>
    ## 1     1     1
    ## 2     1     2
    ## 3     1     3
    ## 4     1     4
    ## 5     2     1

``` r
df1 <- tribble(
  ~x, ~y,           ~z,
   1, c("a", "b"), 1:2,
   2, "c",           3
)
df1
```

    ## # A tibble: 2 × 3
    ##       x y         z        
    ##   <dbl> <list>    <list>   
    ## 1     1 <chr [2]> <int [2]>
    ## 2     2 <chr [1]> <dbl [1]>

``` r
df1 %>% unnest(c(y, z))
```

    ## # A tibble: 3 × 3
    ##       x y         z
    ##   <dbl> <chr> <dbl>
    ## 1     1 a         1
    ## 2     1 b         2
    ## 3     2 c         3

## 25.6 Sử dụng broom để tidy data

1.  broom::glance, để trả lại kết quả đánh giá quality và complexity của
    model
2.  broom::tidy trả lại coefficient cho từng model
3.  broom::augment(model, data), thêm residuals và influence statistics
