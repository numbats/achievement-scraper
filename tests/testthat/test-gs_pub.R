test_that("get_publications_from_scholar returns a valid data frame", {
  scholar_id <- "vamErfkAAAAJ"
  result <- get_publications_from_scholar(scholar_id)
  expect_s3_class(result, "data.frame")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_true(nrow(result) > 0)
})


test_that("get_publications_from_scholar handles missing DOI, journal, or year columns", {
  result <- get_publications_from_scholar("vamErfkAAAAJ")
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("DOI", "journal_name", "publication_year") %in% colnames(result)))
  expect_true(!is.null(result$DOI))
  expect_true(!is.null(result$journal_name))
  expect_true(!is.null(result$publication_year))
})


test_that("get_publications_from_scholar handles empty input", {
  scholar_id <- character(0)
  result <- get_publications_from_scholar(scholar_id)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
}) #not working

test_that("get_publications_from_scholar returns no NA values in publication_year", {
  result <- get_publications_from_scholar("vamErfkAAAAJ")
  expect_true("publication_year" %in% colnames(result))
  expect_false(any(is.na(result$publication_year)))
}) #NA values in publication_year

test_that("get_publications_from_scholar handles invalid Google Scholar ID", {
  scholar_id <- "invalid_Scholar_ID"
  expect_error(get_publications_from_scholar(scholar_id), "Invalid SCHOLAR ID")
})#not working


