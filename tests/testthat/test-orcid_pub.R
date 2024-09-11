test_that("get_publications_from_orcid handles empty input", {
  orcid_ids <- character(0)
  result <- get_publications_from_orcid(orcid_ids)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("get_publications_from_orcid returns a valid data frame", {
  orcid_ids <- c("0000-0002-2140-5352", "0000-0001-6515-827X")
  result <- get_publications_from_orcid(orcid_ids)
  expect_s3_class(result, "data.frame")
  expect_true(all(c("title", "DOI", "authors", "publication_date", "journal_name", "orcid_id") %in% colnames(result)))
  expect_true(nrow(result) > 0)
})
#orcid_id <- 0000-0001-9379-0010 (Charanjit Kaur)

test_that("get_publications_from_orcid returns empty data frame for ORCID with no works", {
  orcid_ids <- c("0009-0008-4231-8291") #parnika
  result <- get_publications_from_orcid(orcid_ids)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})

test_that("get_publications_from_orcid returns empty data frame for invalid ORCID IDs", {
  orcid_ids <- c("0000-0000-0000-0000")
  result <- get_publications_from_orcid(orcid_ids)
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 0)
})
