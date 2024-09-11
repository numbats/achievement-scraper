test_that("get_publications_from_scholar returns a valid data frame", {
  scholar_id <- "vamErfkAAAAJ"
  result <- get_publications_from_scholar(scholar_id)
  expect_s3_class(result, "data.frame")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_true(nrow(result) > 0)
})

test_that("get_publications_from_scholar handles empty input", {
  scholar_id <- ""
  result <- get_publications_from_scholar(scholar_id)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("get_publications_from_scholar handles invalid Google Scholar ID", {
  scholar_id <- "invalidID"
  result <- get_publications_from_scholar(scholar_id)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})
