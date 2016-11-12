context("qiita_get_tags")

skip_on_cran()

test_that("qiita_get_tags with tag ID", {
  tags <- qiita_get_tags(tag_id = "R")
  expect_equal(length(tags), 1)
  expect_equal(tags[[1]]$id, "R")
})

test_that("qiita_get_tags with multiple tag IDs", {
  tags <- qiita_get_tags(tag_id = c("R", "dplyr"))
  expect_equal(length(tags), 2)
  expect_equal(purrr::map_chr(tags, "id"), c("R", "dplyr"))
})

test_that("qiita_get_tags with user ID", {
  tags <- qiita_get_tags(user_id = "yutannihilation")
  expect_true("R" %in% purrr::map_chr(tags, "id"))
})

test_that("qiita_is_following_tag works.", {
  expect_true(qiita_is_following_tag("R"))
})
