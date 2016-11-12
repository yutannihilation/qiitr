context("qiita_get_items")

test_that("qiita_get_items", {
  expect_equal(qiita_get_items(tag_id = "R", per_page = 3L, page_limit = 1L),
               qiita_get_items(tag_id = "R", per_page = 1L, page_limit = 3L))
})
