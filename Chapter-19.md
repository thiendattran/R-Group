Chapter 19
================
Dat
2023-02-16

# 19. Function

## 19.1 Lợi ích của function

3 Lợi ích của việc viết một function:

- Tự đặt tên function để dễ hiểu

- Nếu cần thiết chỉ cần thay đổi function cho toàn bộ kết quả

- Tránh sai sót khi copy and paste

Những function trong chương này đều đã có trong R base và không cần
tidyverse

## 19.2 Khi nào cần tạo function

Ví dụ trong trường hợp này ta cần thay đổi scale của 4 cột a, b, c, d
thành từ 0 đến 1.

Dùng copy and paste nhưng lại không đổi tên biến 1 dòng -\> sai sót
không thấy được

``` r
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

df$a <- (df$a - min(df$a, na.rm = TRUE)) / 
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) / 
  (max(df$b, na.rm = TRUE) - min(df$a, na.rm = TRUE)) # lỗi sai
df$c <- (df$c - min(df$c, na.rm = TRUE)) / 
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) / 
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))
```

Dùng function để giải quyết cái trường hợp cần lặp lại 1 phương thức
chuyển dổi.

Đầu tiên cần phải xác định có bao nhiêu input trong 1 đoạn trước

``` r
(df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
```

    ##  [1] 0.7245723 0.0000000 0.4213848 0.8625028 0.8498481 0.5122021 0.6543174
    ##  [8] 1.0000000 0.4604045 0.4443440

Đoạn này chỉ sử dụng 1 input là df\$a.

Thay thế input này bằng x

``` r
x <- df$a
(x - min(x, na.rm = TRUE)) / (max(x, na.rm = TRUE) - min(x, na.rm = TRUE))
```

    ##  [1] 0.7245723 0.0000000 0.4213848 0.8625028 0.8498481 0.5122021 0.6543174
    ##  [8] 1.0000000 0.4604045 0.4443440

Dùng range để thay thế cho min max để gọn code. rng\[1\] tương đường giá
trị min và rng\[2\] sẽ cho giá trị max

``` r
rng <- range(x, na.rm = TRUE)
(x - rng[1]) / (rng[2] - rng[1])
```

    ##  [1] 0.7245723 0.0000000 0.4213848 0.8625028 0.8498481 0.5122021 0.6543174
    ##  [8] 1.0000000 0.4604045 0.4443440

Sau khi đã có công thức chung, đơn giản hoá code, ta có thể biến nó
thành 1 function với tên tuỳ chọn, ở đây chọn đặt tên function là
“rescale01”

``` r
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1])/(rng[2] - rng[1])
}
rescale01(c(0, 5, 10))
```

    ## [1] 0.0 0.5 1.0

Ba vấn đề quan trong khi viết function:

1.  Phải chọn tên cho function (chọn dễ hiểu và tránh trùng lặp). Ở đây
    mình chọn **rescale01** để gọi function chuyển vector thành từ 0 đến
    1
2.  Cần xác định input hoặc argument cần cho function. ví dụ nếu mình
    cần 3 input thì sử dụng: tên_function (x, y, z)
3.  Copy code rút gọn vào giữa 2 ngoặc {}

Test thử function

``` r
rescale01(c(-10,0,10))
```

    ## [1] 0.0 0.5 1.0

``` r
rescale01(c(1, 2, 3, NA, 5))
```

    ## [1] 0.00 0.25 0.50   NA 1.00

Sử dụng function dùng trong ví dụ ban đầu

``` r
df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)
```

### Exercice

``` r
rescale01(c(1, -Inf, 2 , 3, NA, 5, 4,10, Inf))
```

    ## [1] NaN NaN NaN NaN  NA NaN NaN NaN NaN

Viết lại function rescale để -Inf thành 0 và Inf 1

## 19.3 Function are for humans and computers

Điều quan trọng khi viết function là phải đặt tên có ý nghĩa để tái sử
dụng và người khác có thể hiểu được code.

Function nên sử dụng động từ và argument (input) nên là danh từ.

- Ví dụ: describe(data), subtract(value1, value2)

- Quá ngắn: f()

- Không phải verb: my_awesome_function()

- Dài nhưng xúc tích: impute_missing(), collapse_years()

Nên đặt tên function nối bằng dấu gạch ngang “\_” hoặc kiểu camelCase.
Nhưng đừng mix 2 kiểu lại với nhau

Tránh đặt tên với những function hay variable đã có sẵn, ví dụ:

- T \<- FALSE

- c \<- 10

- mean \<- function(x) sum(x)

## 19.4 Câu điều kiện (If statement)

``` r
if (condition) {
  # code executed when condition is TRUE
} else {
  # code executed when condition is FALSE
}
```

Ví dụ một function sử dụng if

``` r
has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}
```

Function này để test xem dataframe có được tên columns chưa, ví dụ:

``` r
has_name(df)
```

    ## [1] TRUE TRUE TRUE TRUE

### 19.4.1 Conditions

Trong Conditions chỉ có thể là TRUE hoặc FALSE, nếu dùng vector có cả
TRUE lẫn FALSE, hoặc có chứ NA R sẽ báo lỗi

``` if

if (NA) {}
```

Mình có thể dùng \|\| (như OR) và && (như AND) đối với TRUE FALSE.

Nếu dùng \|\| sẽ tự động return TRUE nếu nó thấy ít nhất một TRUE

Nếu dùng && sẽ return FALSE nếu function thấy ít nhất một FALSE

Không nên sử dụng \| và & trong if statement: vì nó chỉ dụng ở dạng
vector.

Nếu chúng ta có 1 vector TRUE FALSE, dùng any() và all() để chuyển thành
1 giá trị duy nhất

== cũng ở dạng vectorised, nghĩa là nó sẽ trả về nhiều hơn một output.
Để sử dụng ở dạng vector, mình có thể sử dụng identical().

Nhưng identical sẽ check luôn cả dạng data

``` r
identical(0L, 0)
```

    ## [1] FALSE

Để so sánh float với interger ta có thể dùng

dplyr::near()

``` r
dplyr::near(0L, 0)
```

    ## [1] TRUE

### 19.4.2 Cách viết nhiều conditions

``` r
if (this) {
  # do that
} else if (that) {
  # do something else
} else {
  # 
}
```

Để tránh sử dụng quá nhiều ifelse

``` r
function(x, y, op) {
   switch(op,
     plus = x + y,
     minus = x - y,
     times = x * y,
     divide = x / y,
     stop("Unknown op!")
   )
 }
```

### 19.4.3 Style khi viết function and condition

Dấu ngoặc mở { luôn luôn nằm chung với dòng lệnh

Dấu ngoặc đóng } luôn luôn nằm riêng 1 hàng

``` r
  # Good
if (y < 0 && debug) {
  message("Y is negative")
}

if (y == 0) {
  log(x)
} else {
  y ^ x
}

  # Bad
if (y < 0 && debug)
message("Y is negative")

if (y == 0) {
  log(x)
} 
else {
  y ^ x
}
```
