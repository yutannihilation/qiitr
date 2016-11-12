qiitr - R Binding for Qiita API
==========================

[![Travis-CI Build Status](https://travis-ci.org/yutannihilation/qiitr.svg?branch=master)](https://travis-ci.org/yutannihilation/qiitr)

*This package is in a very early state and is experimental. You've been warned!*

## About Qiita

About Qiita: http://qiita.com/about
API Document: http://qiita.com/api/v2/docs

## Installation

```r
devtools::install_github("yutannihilation/qiitr")
```

## Usage

```r
q <- Qiita$new(token = "abcdefghijk")
q$get_item(tag_id = "ggplot2逆引き", page_limit = 5L)
```
