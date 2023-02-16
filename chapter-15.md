FACTORS
================
LUONG PHAM THAO VAN
2023-02-12

# Introduction

Factors are used to work with categorical variables

# Các function sử dụng trong trong chapter

sort(): sắp xếp dữ liệu trong array.  
factor(): gắn levels cho variables.  
parse_factor(): gắn levels cho factors nhưng có báo warning.  
fct_reorder(): sắp xếp factor lại theo một biến khác.  
fct_relevel(): đưa lại level ban đầu + ưu tiên level nào.  
fct_reorder2(): sắp xếp factor lại theo 2 biến khác.  
fct_recode(): đổi tên level của factor lại.  
fct_rev(): đảo ngược lại.  
fct_infreq(): đổi factor theo tuần suất xuất hiện tăng dần.  
fct_collapse(): nhập nhiều level thành 1 level.  
fct_lump_n(): giữ level có tuần suất cao nhất, và gộp các level còn lại
thành một.  
fct_collapse(): ghép các level lại thành một level.  
fct_infreq(): sắp xếp theo tần suát xuất hiện level.

Factor level không phải là biến ordinal mà chỉ để sắp xếp thứ tự xuất
hiện và quy định các giá trị mặc định. \# Pratice

``` r
library(tidyverse)
```

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
    ## ✔ ggplot2 3.4.0     ✔ purrr   1.0.1
    ## ✔ tibble  3.1.8     ✔ dplyr   1.1.0
    ## ✔ tidyr   1.3.0     ✔ stringr 1.5.0
    ## ✔ readr   2.1.3     ✔ forcats 1.0.0
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

a string is sorted by alphabet

``` r
x1 <- c("Dec","Apr","Jan","Mar")
sort(x1)
```

    ## [1] "Apr" "Dec" "Jan" "Mar"

a string is sorted by month

``` r
month_levels <- c("Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec")

y1<- factor(x1, levels=month_levels)
y1
```

    ## [1] Dec Apr Jan Mar
    ## Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

``` r
sort(y1)
```

    ## [1] Jan Mar Apr Dec
    ## Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

``` r
x2 <- c("Apr","Jam","aug","Nov")
sort(x2)
```

    ## [1] "Apr" "aug" "Jam" "Nov"

``` r
y2 <- factor(x2,levels=month_levels)
y2
```

    ## [1] Apr  <NA> <NA> Nov 
    ## Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

warning

``` r
parse_factor(x2,levels=month_levels)
```

    ## Warning: 2 parsing failures.
    ## row col           expected actual
    ##   2  -- value in level set    Jam
    ##   3  -- value in level set    aug

    ## [1] Apr  <NA> <NA> Nov 
    ## attr(,"problems")
    ## # A tibble: 2 × 4
    ##     row   col expected           actual
    ##   <int> <int> <chr>              <chr> 
    ## 1     2    NA value in level set Jam   
    ## 2     3    NA value in level set aug   
    ## Levels: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec

alphabetical order in a factor

``` r
factor(x1)
```

    ## [1] Dec Apr Jan Mar
    ## Levels: Apr Dec Jan Mar

keep the order of the first appearance in the data

``` r
factor(x1, levels= unique(x1))
```

    ## [1] Dec Apr Jan Mar
    ## Levels: Dec Apr Jan Mar

or

``` r
f2 <- x1 %>% factor() %>% fct_inorder()
f2
```

    ## [1] Dec Apr Jan Mar
    ## Levels: Dec Apr Jan Mar

access the set of valid levels directly

``` r
levels(f2)
```

    ## [1] "Dec" "Apr" "Jan" "Mar"

``` r
gss_cat
```

    ## # A tibble: 21,483 × 9
    ##     year marital         age race  rincome        partyid    relig denom tvhours
    ##    <int> <fct>         <int> <fct> <fct>          <fct>      <fct> <fct>   <int>
    ##  1  2000 Never married    26 White $8000 to 9999  Ind,near … Prot… Sout…      12
    ##  2  2000 Divorced         48 White $8000 to 9999  Not str r… Prot… Bapt…      NA
    ##  3  2000 Widowed          67 White Not applicable Independe… Prot… No d…       2
    ##  4  2000 Never married    39 White Not applicable Ind,near … Orth… Not …       4
    ##  5  2000 Divorced         25 White Not applicable Not str d… None  Not …       1
    ##  6  2000 Married          25 White $20000 - 24999 Strong de… Prot… Sout…      NA
    ##  7  2000 Never married    36 White $25000 or more Not str r… Chri… Not …       3
    ##  8  2000 Divorced         44 White $7000 to 7999  Ind,near … Prot… Luth…      NA
    ##  9  2000 Married          44 White $25000 or more Not str d… Prot… Other       0
    ## 10  2000 Married          47 White $25000 or more Strong re… Prot… Sout…       3
    ## # … with 21,473 more rows

load data (gss_cat: general social survey)

``` r
gss_cat %>% select(partyid, relig,denom)
```

    ## # A tibble: 21,483 × 3
    ##    partyid            relig              denom            
    ##    <fct>              <fct>              <fct>            
    ##  1 Ind,near rep       Protestant         Southern baptist 
    ##  2 Not str republican Protestant         Baptist-dk which 
    ##  3 Independent        Protestant         No denomination  
    ##  4 Ind,near rep       Orthodox-christian Not applicable   
    ##  5 Not str democrat   None               Not applicable   
    ##  6 Strong democrat    Protestant         Southern baptist 
    ##  7 Not str republican Christian          Not applicable   
    ##  8 Ind,near dem       Protestant         Lutheran-mo synod
    ##  9 Not str democrat   Protestant         Other            
    ## 10 Strong republican  Protestant         Southern baptist 
    ## # … with 21,473 more rows

``` r
?gss_cat
```

``` r
gss_cat %>% count(race)
```

    ## # A tibble: 3 × 2
    ##   race      n
    ##   <fct> <int>
    ## 1 Other  1959
    ## 2 Black  3129
    ## 3 White 16395

``` r
gss_cat %>% ggplot(aes(race))+
  geom_bar()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-14-1.png)<!-- -->

ggplot() sẽ không vẽ những modalite ko có giá trị (mặc định) -\> drop =
FALSE để hiện tất cả modalité lên biểu đồ

``` r
levels(gss_cat$race)
```

    ## [1] "Other"          "Black"          "White"          "Not applicable"

``` r
ggplot(gss_cat,aes(race))+
  geom_bar()+
  scale_x_discrete(drop=FALSE)
```

![](chapter-15_files/figure-gfm/unnamed-chunk-16-1.png)<!-- -->

``` r
gss_cat %>% select(rincome)
```

    ## # A tibble: 21,483 × 1
    ##    rincome       
    ##    <fct>         
    ##  1 $8000 to 9999 
    ##  2 $8000 to 9999 
    ##  3 Not applicable
    ##  4 Not applicable
    ##  5 Not applicable
    ##  6 $20000 - 24999
    ##  7 $25000 or more
    ##  8 $7000 to 7999 
    ##  9 $25000 or more
    ## 10 $25000 or more
    ## # … with 21,473 more rows

``` r
gss_cat %>% ggplot(aes(rincome))+
  geom_bar()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-18-1.png)<!-- -->

``` r
gss_cat %>% count(relig)
```

    ## # A tibble: 15 × 2
    ##    relig                       n
    ##    <fct>                   <int>
    ##  1 No answer                  93
    ##  2 Don't know                 15
    ##  3 Inter-nondenominational   109
    ##  4 Native american            23
    ##  5 Christian                 689
    ##  6 Orthodox-christian         95
    ##  7 Moslem/islam              104
    ##  8 Other eastern              32
    ##  9 Hinduism                   71
    ## 10 Buddhism                  147
    ## 11 Other                     224
    ## 12 None                     3523
    ## 13 Jewish                    388
    ## 14 Catholic                 5124
    ## 15 Protestant              10846

``` r
relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-20-1.png)<!-- -->

``` r
gss_cat %>% group_by(denom,relig) %>% 
  summarise(n=n())
```

    ## `summarise()` has grouped output by 'denom'. You can override using the
    ## `.groups` argument.

    ## # A tibble: 47 × 3
    ## # Groups:   denom [30]
    ##    denom           relig          n
    ##    <fct>           <fct>      <int>
    ##  1 No answer       No answer     93
    ##  2 No answer       Christian      2
    ##  3 No answer       Protestant    22
    ##  4 Don't know      Christian     11
    ##  5 Don't know      Protestant    41
    ##  6 No denomination Christian    452
    ##  7 No denomination Other          7
    ##  8 No denomination Protestant  1224
    ##  9 Other           Protestant  2534
    ## 10 Episcopal       Protestant   397
    ## # … with 37 more rows

``` r
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-22-1.png)<!-- -->

``` r
x2 = tibble(
  n= c(1,2,5,3,0),
  alb= c("b","c","a","e","d"))
x2
```

    ## # A tibble: 5 × 2
    ##       n alb  
    ##   <dbl> <chr>
    ## 1     1 b    
    ## 2     2 c    
    ## 3     5 a    
    ## 4     3 e    
    ## 5     0 d

``` r
x2 %>% ggplot(aes(n,fct_reorder(alb,n)))+ geom_point()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-23-1.png)<!-- -->

``` r
relig_summary %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
    geom_point()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-24-1.png)<!-- -->

``` r
age_summary <- gss_cat %>% group_by(rincome) %>% 
  summarise(age=mean(age, na.rm=TRUE),
            n=n())
ggplot(age_summary,aes(age,fct_reorder(rincome,age)))+ geom_point()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-25-1.png)<!-- -->

``` r
levels(gss_cat$rincome)
```

    ##  [1] "No answer"      "Don't know"     "Refused"        "$25000 or more"
    ##  [5] "$20000 - 24999" "$15000 - 19999" "$10000 - 14999" "$8000 to 9999" 
    ##  [9] "$7000 to 7999"  "$6000 to 6999"  "$5000 to 5999"  "$4000 to 4999" 
    ## [13] "$3000 to 3999"  "$1000 to 2999"  "Lt $1000"       "Not applicable"

``` r
ggplot(age_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-27-1.png)<!-- -->

``` r
f <- factor(c("a", "b", "c", "d"), levels = c("b", "c", "d", "a"))
f
```

    ## [1] a b c d
    ## Levels: b c d a

``` r
fct_relevel(f)
```

    ## [1] a b c d
    ## Levels: b c d a

``` r
fct_relevel(f, "a")
```

    ## [1] a b c d
    ## Levels: a b c d

``` r
fct_relevel(f, "b", "a")
```

    ## [1] a b c d
    ## Levels: b a c d

Move to the third position

``` r
fct_relevel(f, "a", after = 2)
```

    ## [1] a b c d
    ## Levels: b c a d

Relevel to the end

``` r
fct_relevel(f, "a", after = Inf)
```

    ## [1] a b c d
    ## Levels: b c d a

``` r
fct_relevel(f, sort)
```

    ## [1] a b c d
    ## Levels: a b c d

changer l’ordre de ‘levels’

``` r
x = c("van","thu","vi")
x= factor(x)

levels(x) <- c("vi","van","thu")
levels(x)
```

    ## [1] "vi"  "van" "thu"

pardéfaut, fct_reorder2() utilise function last2 (trier les valeurs de
‘prop’ à la dernière groupe d’âge(89 ans) first2: trier les valeurs de
‘prop’ à la première groupe d’âge(18 ans) labs() = labels

``` r
by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)
```

![](chapter-15_files/figure-gfm/unnamed-chunk-33-1.png)<!-- -->

``` r
ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")
```

![](chapter-15_files/figure-gfm/unnamed-chunk-33-2.png)<!-- -->

``` r
ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop,.fun = first2))) +
  geom_line() +
  labs(colour = "marital")
```

![](chapter-15_files/figure-gfm/unnamed-chunk-33-3.png)<!-- -->

fct_rev() renverse order of factor levels fct_infreq() reorder factor
levels by frequency

``` r
gss_cat %>% count(marital)
```

    ## # A tibble: 6 × 2
    ##   marital           n
    ##   <fct>         <int>
    ## 1 No answer        17
    ## 2 Never married  5416
    ## 3 Separated       743
    ## 4 Divorced       3383
    ## 5 Widowed        1807
    ## 6 Married       10117

``` r
gss_cat %>% ggplot(aes(marital))+
  geom_bar()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-34-1.png)<!-- -->

``` r
gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
    geom_bar()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-34-2.png)<!-- -->

``` r
gss_cat %>%
  mutate(marital = marital %>% fct_infreq()) %>%
  ggplot(aes(marital)) +
    geom_bar()
```

![](chapter-15_files/figure-gfm/unnamed-chunk-34-3.png)<!-- -->

# recode levels

``` r
levels(gss_cat$partyid)
```

    ##  [1] "No answer"          "Don't know"         "Other party"       
    ##  [4] "Strong republican"  "Not str republican" "Ind,near rep"      
    ##  [7] "Independent"        "Ind,near dem"       "Not str democrat"  
    ## [10] "Strong democrat"

``` r
gss_cat %>%  count(partyid)
```

    ## # A tibble: 10 × 2
    ##    partyid                n
    ##    <fct>              <int>
    ##  1 No answer            154
    ##  2 Don't know             1
    ##  3 Other party          393
    ##  4 Strong republican   2314
    ##  5 Not str republican  3032
    ##  6 Ind,near rep        1791
    ##  7 Independent         4119
    ##  8 Ind,near dem        2499
    ##  9 Not str democrat    3690
    ## 10 Strong democrat     3490

``` r
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat"
  )) %>%
  count(partyid)
```

    ## # A tibble: 10 × 2
    ##    partyid                   n
    ##    <fct>                 <int>
    ##  1 No answer               154
    ##  2 Don't know                1
    ##  3 Other party             393
    ##  4 Republican, strong     2314
    ##  5 Republican, weak       3032
    ##  6 Independent, near rep  1791
    ##  7 Independent            4119
    ##  8 Independent, near dem  2499
    ##  9 Democrat, weak         3690
    ## 10 Democrat, strong       3490

# combine groups : created group is “Other” with fct_recode()

``` r
gss_cat %>%
  mutate(partyid = fct_recode(partyid,
    "Republican, strong"    = "Strong republican",
    "Republican, weak"      = "Not str republican",
    "Independent, near rep" = "Ind,near rep",
    "Independent, near dem" = "Ind,near dem",
    "Democrat, weak"        = "Not str democrat",
    "Democrat, strong"      = "Strong democrat",
    "Other"                 = "No answer",
    "Other"                 = "Don't know",
    "Other"                 = "Other party"
  )) %>%
  count(partyid)
```

    ## # A tibble: 8 × 2
    ##   partyid                   n
    ##   <fct>                 <int>
    ## 1 Other                   548
    ## 2 Republican, strong     2314
    ## 3 Republican, weak       3032
    ## 4 Independent, near rep  1791
    ## 5 Independent            4119
    ## 6 Independent, near dem  2499
    ## 7 Democrat, weak         3690
    ## 8 Democrat, strong       3490

combine group: created new group with fct_collapse() grouper plusieurs
levels en même ligne

``` r
gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
    other = c("No answer", "Don't know", "Other party"),
    rep = c("Strong republican", "Not str republican"),
    ind = c("Ind,near rep", "Independent", "Ind,near dem"),
    dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)
```

    ## # A tibble: 4 × 2
    ##   partyid     n
    ##   <fct>   <int>
    ## 1 other     548
    ## 2 rep      5346
    ## 3 ind      8409
    ## 4 dem      7180

grouper tous les petites groupes dans un groupe qui est comparé à le
plus grand groupe (other et protestant)

``` r
gss_cat %>% count(relig)
```

    ## # A tibble: 15 × 2
    ##    relig                       n
    ##    <fct>                   <int>
    ##  1 No answer                  93
    ##  2 Don't know                 15
    ##  3 Inter-nondenominational   109
    ##  4 Native american            23
    ##  5 Christian                 689
    ##  6 Orthodox-christian         95
    ##  7 Moslem/islam              104
    ##  8 Other eastern              32
    ##  9 Hinduism                   71
    ## 10 Buddhism                  147
    ## 11 Other                     224
    ## 12 None                     3523
    ## 13 Jewish                    388
    ## 14 Catholic                 5124
    ## 15 Protestant              10846

``` r
gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)
```

    ## # A tibble: 2 × 2
    ##   relig          n
    ##   <fct>      <int>
    ## 1 Protestant 10846
    ## 2 Other      10637

fct_lump with required number of group

``` r
gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig, sort = TRUE) %>%
  print(n = Inf)
```

    ## # A tibble: 10 × 2
    ##    relig                       n
    ##    <fct>                   <int>
    ##  1 Protestant              10846
    ##  2 Catholic                 5124
    ##  3 None                     3523
    ##  4 Christian                 689
    ##  5 Other                     458
    ##  6 Jewish                    388
    ##  7 Buddhism                  147
    ##  8 Inter-nondenominational   109
    ##  9 Moslem/islam              104
    ## 10 Orthodox-christian         95
