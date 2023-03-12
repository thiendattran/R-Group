VECTOR
================
2023-03-11

import library

Lý thuyết : 2 types of vector : - Atomic vector(homogenerous) : logical
(boulean : T/F), int (số nguyên), double (float : số thập phân),
character (string: kí tự), complex, raw.

- Lists (heterogeneous) : a = list(1,2,‘b’,1.5) (recursive vectors : đệ
  quy) : b =list(1,2,3,list(‘a’,‘b’,‘c’))

- NULL/NA : absence of vector, vector of length 0

``` r
knitr::include_graphics("C:/Users/HaoLE/Downloads/data-structures-overview.png")
```

<img src="data-structures-overview.png" width="1354" />

2 properties :

-type

``` r
print(letters)
```

    ##  [1] "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m" "n" "o" "p" "q" "r" "s"
    ## [20] "t" "u" "v" "w" "x" "y" "z"

``` r
print(1:10)
```

    ##  [1]  1  2  3  4  5  6  7  8  9 10

``` r
typeof(letters)
```

    ## [1] "character"

``` r
typeof(1:10)
```

    ## [1] "integer"

-length

``` r
x <- list("a", "b", 1:10)
print(x)  # biễu diễn list x
```

    ## [[1]]
    ## [1] "a"
    ## 
    ## [[2]]
    ## [1] "b"
    ## 
    ## [[3]]
    ##  [1]  1  2  3  4  5  6  7  8  9 10

``` r
typeof(x)  #check data type của 1 list
```

    ## [1] "list"

``` r
length(x)  #check độ dài của list
```

    ## [1] 3

``` r
#sapply(x, class) #check data type của từng data point trong list
#str(x)
```

``` r
my_list <- list(name = "John",
                age = 30,
                hobbies = c("reading", "hiking", "cooking"),
                contact = list(phone = "555-1234", email = "john@example.com"))
typeof(my_list)
```

    ## [1] "list"

``` r
length(my_list)
```

    ## [1] 4

``` r
#sapply(my_list, class)
```

There are three important types of augmented vectors: -factors (int)
-dates and date-times (double) -data frames or tibbles (list)

Logical

``` r
1:10 %% 3 == 0  #từ 1 đến 10 số nào chia hết cho 3
```

    ##  [1] FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE FALSE  TRUE FALSE

``` r
c(TRUE, TRUE, FALSE, NA)
```

    ## [1]  TRUE  TRUE FALSE    NA

In R, numbers are doubles by default. To make an integer, place an L
after the number:

``` r
typeof(1)
```

    ## [1] "double"

``` r
typeof(1L)
```

    ## [1] "integer"

``` r
1.5L
```

    ## [1] 1.5

``` r
typeof(1.5L)
```

    ## [1] "double"

In the third line, 1.5L returns a numeric value of 1.5 because R
automatically coerces the integer 1L to a double-precision
floating-point number before performing the arithmetic operation.
However, the typeof() function would still return “double” because the
resulting value is a double-precision floating-point number.

``` r
x <- sqrt(2) ^ 2 #căn bậc 2 mũ 2
x
```

    ## [1] 2

``` r
x - 2  #0.0000000000000004440892
```

    ## [1] 4.440892e-16

Instead of comparing floating point numbers using ==, you should use
dplyr::near() which allows for some numerical tolerance.

int : NA double : NA, NaN, -Inf, Inf

``` r
c(-1, 0, 1) / 0
```

    ## [1] -Inf  NaN  Inf

is.finite() : 0  
is.infinite() : Inf is.na() : NA is.nan() : NaN

``` r
is.finite(0)     #returns TRUE because 0 is a finite number.
```

    ## [1] TRUE

``` r
is.infinite(Inf) #returns TRUE because Inf represents positive infinity.
```

    ## [1] TRUE

``` r
is.na(NA)        #returns TRUE because NA represents a missing value.
```

    ## [1] TRUE

``` r
is.nan(NaN)      #returns TRUE because NaN represents a not-a-number value (chia cho 0/lấy căn số âm)
```

    ## [1] TRUE

``` r
#install.packages("pryr")
#library(pryr)


x <- "This is a reasonably long string."
pryr::object_size(x)
```

    ## 152 B

``` r
y <- rep(x, 1000)
head(y, n=5)
```

    ## [1] "This is a reasonably long string." "This is a reasonably long string."
    ## [3] "This is a reasonably long string." "This is a reasonably long string."
    ## [5] "This is a reasonably long string."

``` r
pryr::object_size(y)
```

    ## 8.14 kB

Normally you don’t need to know about these different types because you
can always use NA and it will be converted to the correct type using the
implicit coercion rules described next.

``` r
NA            # logical
```

    ## [1] NA

``` r
NA_integer_   # integer
```

    ## [1] NA

``` r
NA_real_      # double
```

    ## [1] NA

``` r
NA_character_ # character
```

    ## [1] NA

Coercion : -explicit coercion : as.logical(), as.integer(), as.double(),
or as.character()

-implicit coercion :

``` r
x <- sample(20, 100, replace = TRUE) #tạo 1 mẫu 100 số có giá trị từ 1 - 20
y <- x > 10
print(x)
```

    ##   [1]  5 15 14 11 16  4 18  8  4  6 20 15 16  9 19 16 16 16 12 19 18  3  8 11 17
    ##  [26]  4 19 15  7 20  1 15 19 12  4  6 14  4  2  7 11  8  5 10  7  3 17 17 11  3
    ##  [51] 17  1 15 15 15 10 18 16 18  9 11 16  3 16  6 10 16 10 13 20 18 11  2 15  3
    ##  [76]  6 20 13 10 20 17 10  3  5 11  3 17 19  1  6 11 13  5  9  3  7  5 15 18  1

``` r
print(y)
```

    ##   [1] FALSE  TRUE  TRUE  TRUE  TRUE FALSE  TRUE FALSE FALSE FALSE  TRUE  TRUE
    ##  [13]  TRUE FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE FALSE FALSE  TRUE
    ##  [25]  TRUE FALSE  TRUE  TRUE FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE FALSE
    ##  [37]  TRUE FALSE FALSE FALSE  TRUE FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE
    ##  [49]  TRUE FALSE  TRUE FALSE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE  TRUE FALSE
    ##  [61]  TRUE  TRUE FALSE  TRUE FALSE FALSE  TRUE FALSE  TRUE  TRUE  TRUE  TRUE
    ##  [73] FALSE  TRUE FALSE FALSE  TRUE  TRUE FALSE  TRUE  TRUE FALSE FALSE FALSE
    ##  [85]  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE
    ##  [97] FALSE  TRUE  TRUE FALSE

``` r
sum(y)  # how many are greater than 10?
```

    ## [1] 55

``` r
mean(y) # what proportion are greater than 10?
```

    ## [1] 0.55

most complex type always wins : logical \< int \< double \< character

``` r
typeof(c(TRUE, 1L))
```

    ## [1] "integer"

``` r
typeof(c(1L, 1.5))
```

    ## [1] "double"

``` r
typeof(c(1.5, "a"))
```

    ## [1] "character"

``` r
#h <- c(1.5, "a", 1L, TRUE)
#typeof(h)
#sapply(h, class)

#g <- list(1.5, "a", 1L, TRUE)
#typeof(g)
#sapply(g,class)
```

lgl int dbl chr list is_logical() : logical  
is_integer() : int  
is_double() : double  
is_numeric() : int , double  
is_character() :character is_atomic() :all trừ list is_list() : list
is_vector() : all

Scalars recycling rules : expand the shortest vector to the same length
as the longest

``` r
sample(10) + 100
```

    ##  [1] 105 103 104 101 107 110 108 106 109 102

``` r
runif(10) > 0.5
```

    ##  [1]  TRUE FALSE  TRUE  TRUE FALSE FALSE  TRUE  TRUE  TRUE FALSE

``` r
1:10 + 1:2
```

    ##  [1]  2  4  4  6  6  8  8 10 10 12

``` r
# 1 2 3 4 5 6 7 8 9 10 
# 1 2 1 2 1 2 1 2 1 2  
```

``` r
1:10 + 1:3
```

    ## Warning in 1:10 + 1:3: la taille d'un objet plus long n'est pas multiple de la
    ## taille d'un objet plus court

    ##  [1]  2  4  6  5  7  9  8 10 12 11

``` r
#1 2 3 4 5 6 7 8 9 10
#1 2 3 1 2 3 1 2 3 1
```

``` r
tibble(x = 1:4, y = 1:2)
```

    ## Error:
    ## ! Tibble columns must have compatible sizes.
    ## • Size 4: Existing data.
    ## • Size 2: Column `y`.
    ## ℹ Only values of size one are recycled.

``` r
tibble(x = 1:4, y = rep(1:2, 2))
```

    ## # A tibble: 4 × 2
    ##       x     y
    ##   <int> <int>
    ## 1     1     1
    ## 2     2     2
    ## 3     3     1
    ## 4     4     2

``` r
tibble(x = 1:4, y = rep(1:2, each = 2))
```

    ## # A tibble: 4 × 2
    ##       x     y
    ##   <int> <int>
    ## 1     1     1
    ## 2     2     1
    ## 3     3     2
    ## 4     4     2

Naming vectors

``` r
c(x = 1, y = 2, z = 4)
```

    ## x y z 
    ## 1 2 4

``` r
set_names(1:3, c("a", "b", "c"))
```

    ## a b c 
    ## 1 2 3

Subsetting

filter() : to filter the rows in a tibble (only works with tibble)
x\[a\] : subsetting function

1.  A numeric vector containing only integers. The integers must either
    be all positive, all negative, or zero.

``` r
x <- c("one", "two", "three", "four", "five")
x[c(3, 2, 5)]
```

    ## [1] "three" "two"   "five"

``` r
x[c(1, 1, 5, 5, 5, 2)]
```

    ## [1] "one"  "one"  "five" "five" "five" "two"

Negative values drop the elements at the specified positions:

``` r
x[c(-1, -3, -5)]
```

    ## [1] "two"  "four"

Error

``` r
#x[c(1, -1)]
x[0] #return no values
```

    ## character(0)

2.  Subsetting with a logical vector keeps all values corresponding to a
    TRUE value. This is most often useful in conjunction with the
    comparison functions.

``` r
x <- c(10, 3, NA, 5, 8, 1, NA)

x[!is.na(x)] # All non-missing values of x
```

    ## [1] 10  3  5  8  1

``` r
x[x %% 2 == 0] # All even (or missing!) values of x
```

    ## [1] 10 NA  8 NA

3.  If you have a named vector, you can subset it with a character
    vector

``` r
x <- c(abc = 1, def = 2, xyz = 5)
x
```

    ## abc def xyz 
    ##   1   2   5

``` r
x[c("xyz", "def")]
```

    ## xyz def 
    ##   5   2

x\[\] : lấy hết tất cả hàng, cột x\[1,\] : lấy hàng đầu tiên. tất cả cột
x\[,-1\]: lấy tất cả hàng, tất cả cột trừ cột đầu tiên

``` r
knitr::include_graphics("C:/Users/HaoLE/Downloads/2019-08-06Done.jpg")
```

<img src="2019-08-06Done.jpg" width="624" />

Recursive vectors (lists)

``` r
x <- list(1, 2, 3)
x
```

    ## [[1]]
    ## [1] 1
    ## 
    ## [[2]]
    ## [1] 2
    ## 
    ## [[3]]
    ## [1] 3

``` r
str(x)
```

    ## List of 3
    ##  $ : num 1
    ##  $ : num 2
    ##  $ : num 3

``` r
x_named <- list(a = 1, b = 2, c = 3)
str(x_named)
```

    ## List of 3
    ##  $ a: num 1
    ##  $ b: num 2
    ##  $ c: num 3

``` r
y <- list("a", 1L, 1.5, TRUE)
str(y)
```

    ## List of 4
    ##  $ : chr "a"
    ##  $ : int 1
    ##  $ : num 1.5
    ##  $ : logi TRUE

``` r
z <- list(list(1, 2), list(3, 4))
str(z)
```

    ## List of 2
    ##  $ :List of 2
    ##   ..$ : num 1
    ##   ..$ : num 2
    ##  $ :List of 2
    ##   ..$ : num 3
    ##   ..$ : num 4

Visualising lists

``` r
x1 <- list(c(1, 2), c(3, 4))
x1
```

    ## [[1]]
    ## [1] 1 2
    ## 
    ## [[2]]
    ## [1] 3 4

``` r
x2 <- list(list(1, 2), list(3, 4))
x2
```

    ## [[1]]
    ## [[1]][[1]]
    ## [1] 1
    ## 
    ## [[1]][[2]]
    ## [1] 2
    ## 
    ## 
    ## [[2]]
    ## [[2]][[1]]
    ## [1] 3
    ## 
    ## [[2]][[2]]
    ## [1] 4

``` r
x3 <- list(1, list(2, list(3)))
x3
```

    ## [[1]]
    ## [1] 1
    ## 
    ## [[2]]
    ## [[2]][[1]]
    ## [1] 2
    ## 
    ## [[2]][[2]]
    ## [[2]][[2]][[1]]
    ## [1] 3

``` r
knitr::include_graphics("C:/Users/HaoLE/Downloads/lists-structure.png")
```

<img src="lists-structure.png" width="813" />

Subsetting

``` r
a <- list(a = 1:3, b = "a string", c = pi, d = list(-1, -5))
a
```

    ## $a
    ## [1] 1 2 3
    ## 
    ## $b
    ## [1] "a string"
    ## 
    ## $c
    ## [1] 3.141593
    ## 
    ## $d
    ## $d[[1]]
    ## [1] -1
    ## 
    ## $d[[2]]
    ## [1] -5

``` r
str(a[1:2])
```

    ## List of 2
    ##  $ a: int [1:3] 1 2 3
    ##  $ b: chr "a string"

``` r
str(a[4])
```

    ## List of 1
    ##  $ d:List of 2
    ##   ..$ : num -1
    ##   ..$ : num -5

``` r
a$a
```

    ## [1] 1 2 3

``` r
a[["a"]]
```

    ## [1] 1 2 3

``` r
knitr::include_graphics("C:/Users/HaoLE/Downloads/lists-subsetting.png")
```

<img src="lists-subsetting.png" width="834" />

Attributes

``` r
x <- 1:10
attr(x, "greeting")
```

    ## NULL

``` r
attr(x, "greeting") <- "Hi!"
attr(x, "farewell") <- "Bye!"
attributes(x)
```

    ## $greeting
    ## [1] "Hi!"
    ## 
    ## $farewell
    ## [1] "Bye!"

Augmented vectors

Factors

``` r
x <- factor(c("ab", "cd", "ab"), levels = c("ab", "cd", "ef"))
typeof(x)
```

    ## [1] "integer"

``` r
attributes(x)
```

    ## $levels
    ## [1] "ab" "cd" "ef"
    ## 
    ## $class
    ## [1] "factor"

Dates and date-times

``` r
x <- as.Date("1971-01-01")
unclass(x)
```

    ## [1] 365

``` r
typeof(x)
```

    ## [1] "double"

``` r
attributes(x)
```

    ## $class
    ## [1] "Date"

``` r
#install.packages("lubridate")
#library(lubridate)

x <- lubridate::ymd_hm("1970-01-01 01:00")
```

    ## Warning: All formats failed to parse. No formats found.

``` r
unclass(x)
```

    ## [1] NA
    ## attr(,"tzone")
    ## [1] "UTC"

``` r
typeof(x)
```

    ## [1] "double"

``` r
attributes(x)
```

    ## $class
    ## [1] "POSIXct" "POSIXt" 
    ## 
    ## $tzone
    ## [1] "UTC"

``` r
attr(x, "tzone") <- "US/Pacific"
x
```

    ## [1] NA

``` r
attr(x, "tzone") <- "US/Eastern"
x
```

    ## [1] NA

``` r
y <- as.POSIXlt(x)
typeof(y)
```

    ## [1] "list"

``` r
attributes(y)
```

    ## $names
    ##  [1] "sec"    "min"    "hour"   "mday"   "mon"    "year"   "wday"   "yday"  
    ##  [9] "isdst"  "zone"   "gmtoff"
    ## 
    ## $class
    ## [1] "POSIXlt" "POSIXt" 
    ## 
    ## $tzone
    ## [1] "US/Eastern" "EST"        "EDT"

Tibbles

``` r
tb <- tibble::tibble(x = 1:5, y = 5:1)
view(tb)
typeof(tb)
```

    ## [1] "list"

``` r
attributes(tb)
```

    ## $class
    ## [1] "tbl_df"     "tbl"        "data.frame"
    ## 
    ## $row.names
    ## [1] 1 2 3 4 5
    ## 
    ## $names
    ## [1] "x" "y"

``` r
df <- data.frame(x = 1:5, y = 5:1)
typeof(df)
```

    ## [1] "list"

``` r
attributes(df)
```

    ## $names
    ## [1] "x" "y"
    ## 
    ## $class
    ## [1] "data.frame"
    ## 
    ## $row.names
    ## [1] 1 2 3 4 5
