library(testthat)
library(publicationsscraper)

test_that("get_publications works correctly", {
  result <- get_publications("dummy_orcid_id", "dummy_scholar_id")

  expect_true(tibble::is_tibble(result))
  expect_named(result, c("title", "authors", "journal", "year", "source"))
  expect_true(nrow(result) > 0)
})
