qiitr - R Binding for Qiita API
==========================

[![Travis-CI Build Status](https://travis-ci.org/yutannihilation/qiitr.svg?branch=master)](https://travis-ci.org/yutannihilation/qiitr)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/yutannihilation/qiitr?branch=master&svg=true)](https://ci.appveyor.com/project/yutannihilation/qiitr)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/qiitr)](https://cran.r-project.org/package=qiitr)

## About Qiita

[Qiita](http://qiita.com/about) is a technical knowledge sharing and collaboration platform for programmers. API Document is here http://qiita.com/api/v2/docs.

## Installation

```r
devtools::install_github("yutannihilation/qiitr")
```

## Preperation

Most of Qiita APIs need authorization by an access token. You can issue access tokens on [application settings](https://qiita.com/settings/applications) with the proper priviledge scope.

qiitr package uses `QIITA_ACCESSTOKEN` environmental variable for authoriation. Add the following to your `.Renviron` file. If you are not familiar with `.Renviron`, please read `?Startup`. The file is usually placed in the directory of `Sys.getenv("R_USER")`.

```r
QIITA_ACCESSTOKEN='(your access token)'
```

Or, you can temporarily set `QIITA_ACCESSTOKEN` by `qiita_set_accesstoken()`.

```r
qiita_set_accesstoken()
```

## Usage

### Get item information

Items means articles on Qiita. `qiita_get_items()` can get items by item IDs, tag IDs or user IDs.

```r
# get items by item ID
qiita_get_items(item_id = "7a78d897810446dd6a3b")

# get items by tag ID
qiita_get_items(tag_id = c("dplyr", "tidyr"), per_pages = 10L, page_limit = 1L)

# get items by user ID
qiita_get_items(user_id = "yutannihilation")
```

### Get user information

`qiita_get_authenticated_user()` returns the current user's information. `qiita_get_users()` returns the information about the specified user.

```r
# get the current user
qiita_get_authenticated_user()

# get a user by id
qiita_get_users("yutannihilation")
```

### Follow/Unfollow tags and users

You can also follow/unfollow  tags and users by qiitr functions. Note that thsese APIs requires write priviledge.

```r
# follow a user
qiita_follow_user("user1")

# unfollow a user
qiita_unfollow_user("user1")

# follow a tag
qiita_follow_tag("RStudio")

# unfollow a tag
qiita_unfollow_tag("RStudio")
```

### Post and edit items

`qiita_post_item()` posts an item. Note that the item is private by default.
You should manually check if the post is valid before make it public. `qiita_update_item()` updates it and `qiita_delete_item()` deletes it.

```r
# post an item
item <- qiita_post_item(title = "test", body = "This is an example.")

browseURL(item$url)

# update the item
qiita_update_item(item$id, title = "test", body = "**This is a strong example!**")

# delete the item
qiita_delete_item(item$id)
```

## Note

### Qiita:Team

Though this package doesn't provide full support for [Qiita:Team](https://teams.qiita.com/)-related APIs, you can set `QIITA_URL` environmental variable to change API endpoints. Please add the following to your `.Renviron`.

```r
QIITA_URL='(your Qiita:Team's URL)'
```
