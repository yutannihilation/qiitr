context("util test")

test_that("qiita_tag test", {
  expect_equal(qiita_tag(name = "R", version = ">3.1"), list(name = "R", version = ">3.1"))
})
