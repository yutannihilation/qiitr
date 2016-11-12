qiitr - R Binding for Qiita API
==========================

[![Travis-CI Build Status](https://travis-ci.org/yutannihilation/qiitr.svg?branch=master)](https://travis-ci.org/yutannihilation/qiitr)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/yutannihilation/qiitr?branch=master&svg=true)](https://ci.appveyor.com/project/yutannihilation/qiitr)

## About Qiita

About Qiita: http://qiita.com/about
API Document: http://qiita.com/api/v2/docs

## Installation

```r
devtools::install_github("yutannihilation/qiitr")
```

## Usage

```r
Sys.setenv(QIITA_ACCESSTOKEN = "abcdefghijk")
qiita_get_items(tag_id = "ggplot2逆引き", page_limit = 5L)
```
