R chapter 14
================
Dat
2/7/2023

``` r
knitr::opts_chunk$set(error = TRUE)
```

## 14 Strings

### 14.1 Tổng quan

Chapter này hướng dẫn cách sử dụng string trong R, học về “regular
expressions” (regexps).

Đầu tiên phải load tidyverse library

``` r
library(tidyverse) #load data tidyver
```

### 14.2 Strings basics

Tạo string bnằng cách sử dụng dấu ngoặc kép ” ” hoặc giữa 2 dấu nháy đơn
’ ’

``` r
string1 <- "This is a string"
string2 <- 'If I want to include a "quote" inside a string, I use single quote '
```

-\> Dùng dấu nháy đơn nếu trong string đã có dấu ngoặc képs

``` r
"This is a string without a closing quote
+
+
+
```

    ## Error: <text>:1:1: unexpected INCOMPLETE_STRING
    ## 3: +
    ## 4: +
    ##    ^

Dùng Espace để thoát ra nếu lỡ tay chạy string mà chưa đóng ngoặc

Cách sử dụng ngoặc kép trong một string

``` r
double_quote <- "\""
single_quote <- '\''
print(double_quote)
```

    ## [1] "\""

``` r
print(single_quote)
```

    ## [1] "'"

Vậy nếu muốn sử dụng dấu \\, phải gõ “\\\\”

``` r
print("\\")
```

    ## [1] "\\"

``` r
writeLines("\\")
```

    ## \

Để xem raw content phải dùng writeLines chứ không phải print

### Các kí tự đặc biệt

``` r
x <- "\u00b5"
x
```

    ## [1] "µ"

## Độ dài của string

Các function base của R khó nhớ -\> sử dụng function từ library stringr
với tên function dễ sử dụng hơn

``` r
str_length(c("a", "R for data science", NA))
```

    ## [1]  1 18 NA

### Cách ghép các strings lại

Dùng function str_c

``` r
str_c ("x","y","z")
```

    ## [1] "xyz"

Ghép strings lại với dấu nối

``` r
str_c("x", "y", sep = ", ")
```

    ## [1] "x, y"

Nhưng khi trong str có NA:

``` r
x <- c("A123", NA)
str_c("<", x, ">")
```

    ## [1] "<A123>" NA

``` r
str_c("<", str_replace_na(x), ">")
```

    ## [1] "<A123>" "<NA>"

str_c là fuction cho vector

``` r
str_c("prefix-", c("a", "b", "c"), "-suffix")
```

    ## [1] "prefix-a-suffix" "prefix-b-suffix" "prefix-c-suffix"

Object nào length = 0 sẽ bị mất trong str_c

``` r
name <- "Hadley"
time_of_day <- "morning"
birthday <- FALSE

str_c(
  "Good ", time_of_day, " ", name, birthday, " and HAPPY BIRTHDAY",
  "."
)
```

    ## [1] "Good morning HadleyFALSE and HAPPY BIRTHDAY."

``` r
str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)
```

    ## [1] "Good morning Hadley."

#### 14.2.3 Subsetting strings

Dùng function str_sub() để tách strings ra. Function này sẽ sử dụng
start and end để tách str ra the vị trí từng kí tự

``` r
x <- c ("Apple", "Banana", "Pear")
str_sub(x, 1, 3)
```

    ## [1] "App" "Ban" "Pea"

``` r
str_sub(x, -3, -1)
```

    ## [1] "ple" "ana" "ear"

str_sub() vẫn chạy nếu như string ngắn hơn position

``` r
str_sub("a", 1, 5)
```

    ## [1] "a"

Đổi string viết hoa thành viết thường

``` r
str_to_lower(x)
```

    ## [1] "apple"  "banana" "pear"

đổi thành viết hoa

``` r
str_to_upper(x)
```

    ## [1] "APPLE"  "BANANA" "PEAR"

locale = “en”

locale = “vie”

locale = “fr”

Xếp alphabet tuỳ theo ngôn ngữ bằng cách chọn locale

``` r
x <- c("apple", "eggplant", "banana")

str_sort(x, locale = "en")  # English
```

    ## [1] "apple"    "banana"   "eggplant"

``` r
str_sort(x, locale = "haw") # Hawaiian
```

    ## [1] "apple"    "eggplant" "banana"

``` r
str_sort(x, locale = "vie")
```

    ## [1] "apple"    "banana"   "eggplant"

function paste() và paste0() thường được sử dụng trong R base và không
nằm trong package stringr

``` r
paste("foo", "bar")
```

    ## [1] "foo bar"

``` r
paste0("foo","bar")
```

    ## [1] "foobar"

paste0 tương đương với str_c

``` r
paste0("foo", "bar")
```

    ## [1] "foobar"

``` r
str_c("foo", "bar")
```

    ## [1] "foobar"

Khác biệt của str_c với paste0 khi có missing values

``` r
str_c("foo", NA)
```

    ## [1] NA

``` r
paste("foo", NA)
```

    ## [1] "foo NA"

``` r
paste0("foo", NA)
```

    ## [1] "fooNA"

str_wrap() để xuống dòng ở các string dài

``` r
str_wrap("Trời ơi cái hàng này dài quá trời") %>% writeLines()
```

    ## Trời ơi cái hàng này dài quá trời

``` r
str_wrap("Trời ơi cái hàng này dài quá trời", width = 10) %>% writeLines()
```

    ## Trời ơi
    ## cái hàng
    ## này dài
    ## quá trời

#### 14.2.3 Tìm strings tương ứng với kí tự

``` r
x <- c("apple", "banana", "pear")
str_view(x, "an")
```

    ## [2] │ b<an><an>a

Dùng dấu . để thay thế các kí tự

``` r
str_view(x, ".a")
```

    ## [2] │ <ba><na><na>
    ## [3] │ p<ea>r

Cách tìm kí tự .

``` r
str_view(c("abc", "a.c", "bef"), "a\\.c")
```

    ## [2] │ <a.c>

cách viết dấu \\

``` r
x <- "a\\b"
writeLines(x)
```

    ## a\b

dấu ^ để match với bắt đầu của string

dấu \$ để match với đuôi của string

``` r
x <- c ("apple", "banana", "pear")
str_view(x, "^a")
```

    ## [1] │ <a>pple

``` r
str_view(x, "r$")
```

    ## [3] │ pea<r>

#### 14.3.4 Ký tự lặp lại

x \<- “1888 is the longest year in Roman numerals: MDCCCLXXXVIII”

- `?`: 0 or 1

- `+`: 1 or more

- `*`: 0 or more

``` r
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
```

    ## [1] │ 1888 is the longest year in Roman numerals: MD<CC><C>LXXXVIII

### 14.4 Tools

#### Detech matches

``` r
x <- c("apple", "banana", "pear")
str_detect(x, "e")
```

    ## [1]  TRUE FALSE  TRUE

Dùng sum để đếm bao nhiêu trường hợp TRUE

``` r
sum(str_detect(words, "^t"))
```

    ## [1] 65

Đếm các từ kết thúc bằng nguyên âm

``` r
sum(str_detect(words,"[aeiou]$"))
```

    ## [1] 271

``` r
# Find all words containing at least one vowel, and negate
no_vowels_1 <- !str_detect(words, "[aeiou]")
# Find all words consisting only of consonants (non-vowels)
no_vowels_2 <- str_detect(words, "^[^aeiou]+$")
words[no_vowels_1]
```

    ## [1] "by"  "dry" "fly" "mrs" "try" "why"

``` r
words[no_vowels_2]
```

    ## [1] "by"  "dry" "fly" "mrs" "try" "why"

Tìm và return các string có chứa kí tự

``` r
words[str_detect(words, "x$")]
```

    ## [1] "box" "sex" "six" "tax"

``` r
str_subset(words, "x$")
```

    ## [1] "box" "sex" "six" "tax"

Muốn đưa kết quả vào tibble

``` r
df <- tibble(
  word = words,
  i = seq_along(word)
)
df
```

    ## # A tibble: 980 × 2
    ##    word         i
    ##    <chr>    <int>
    ##  1 a            1
    ##  2 able         2
    ##  3 about        3
    ##  4 absolute     4
    ##  5 accept       5
    ##  6 account      6
    ##  7 achieve      7
    ##  8 across       8
    ##  9 act          9
    ## 10 active      10
    ## # … with 970 more rows

``` r
df %>% filter(str_detect(word, "x$"))
```

    ## # A tibble: 4 × 2
    ##   word      i
    ##   <chr> <int>
    ## 1 box     108
    ## 2 sex     747
    ## 3 six     772
    ## 4 tax     841

Tạo bảng đếm số nguyên âm và phụ âm

``` r
df %>% 
  mutate(
    vowels = str_count(word, "[aeiou]"),
    consonants = str_count(word, "[^aeiou]")
  )
```

    ## # A tibble: 980 × 4
    ##    word         i vowels consonants
    ##    <chr>    <int>  <int>      <int>
    ##  1 a            1      1          0
    ##  2 able         2      2          2
    ##  3 about        3      3          2
    ##  4 absolute     4      4          4
    ##  5 accept       5      2          4
    ##  6 account      6      3          4
    ##  7 achieve      7      4          3
    ##  8 across       8      2          4
    ##  9 act          9      1          2
    ## 10 active      10      3          3
    ## # … with 970 more rows
