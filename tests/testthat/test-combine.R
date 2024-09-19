# Unit tests for get_publications
test_that("get_publications returns a dataframe with valid ORCID and Scholar IDs", {
  result <- get_publications("0000-0002-2140-5352", "vamErfkAAAAJ")
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_true(any(!is.na(result$publication_year)))
  expect_gt(nrow(result), 0)
})

test_that("get_publications returns publications for Scholar ID and NA ORCID", {
  result <- get_publications(NA, "vamErfkAAAAJ")
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_gt(nrow(result), 0)
})

test_that("get_publications returns publications for ORCID ID and NA Scholar ID", {
  result <- get_publications("0000-0002-2140-5352", NA)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_gt(nrow(result), 0)
})

test_that("get_publications returns empty dataframe for NA ORCID and NA Scholar ID", {
  result <- get_publications(NA, NA)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("get_publications fills missing columns with NA", {
  result <- get_publications("0000-0002-2140-5352", NA)
  expect_s3_class(result, "tbl_df")
  required_cols <- c("title", "DOI", "authors", "publication_year", "journal_name")
  expect_true(all(required_cols %in% colnames(result)))
  expect_true(all(!is.null(result$title)))
})

#  Unit tests for get_all_publications
test_that("get_all_publications returns a dataframe with valid ORCID and Scholar IDs", {
  authors_df <- tibble::tibble(
    orcid_id = c("0000-0002-2140-5352", "0000-0002-1825-0097"),
    scholar_id = c("vamErfkAAAAJ", NA))
  result <- get_all_publications(authors_df)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_true(any(!is.na(result$publication_year)))
  expect_gt(nrow(result), 0)
})

test_that("get_all_publications returns publications for NA ORCID and valid Scholar ID", {
  authors_df <- tibble::tibble(
    orcid_id = c(NA),
    scholar_id = c("vamErfkAAAAJ"))
  result <- get_all_publications(authors_df)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_gt(nrow(result), 0)
})

test_that("get_all_publications returns publications for valid ORCID and NA Scholar ID", {
  authors_df <- tibble::tibble(
    orcid_id = c("0000-0002-2140-5352"),
    scholar_id = c(NA))
  result <- get_all_publications(authors_df)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_gt(nrow(result), 0)
})


test_that("get_all_publications returns empty dataframe for NA ORCID and NA Scholar ID", {
  authors_df <- tibble::tibble(
    orcid_id = c(NA),
    scholar_id = c(NA))
  result <- get_all_publications(authors_df)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("get_all_publications handles NAs properly", {
  authors_df <- tibble::tibble(
    orcid_id = c("0000-0002-2140-5352", NA, "0000-0001-5109-3700"),
    scholar_id = c(NA, "vamErfkAAAAJ", NA)
  )
  result <- get_all_publications(authors_df)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("title", "DOI", "authors", "publication_year", "journal_name") %in% colnames(result)))
  expect_gt(nrow(result), 0)
})

# Unit tests for cran_all_pubs
test_that("cran_all_pubs returns a dataframe for valid authors", {
  cran_authors <- tibble::tibble(
    first_name = c("Michael", "Rob"),
    last_name = c("Lydeamore", "Hyndman"))
  result <- cran_all_pubs(cran_authors)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("name", "downloads", "authors", "last_update_date") %in% colnames(result)))
  years <- format(as.Date(result$last_update_date), "%Y")
  expect_true(all(!is.na(years)))
  expect_gt(nrow(result), 0)
})

test_that("cran_all_pubs returns a dataframe for a single valid author", {
  cran_authors <- tibble::tibble(
    first_name = "Rob",
    last_name = "Hyndman")
  result <- cran_all_pubs(cran_authors)
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("name", "downloads", "authors", "last_update_date") %in% colnames(result)))
  expect_gt(nrow(result), 0)
})

test_that("cran_all_pubs returns empty dataframe for unknown authors", {
  cran_authors <- tibble::tibble(
    first_name = c("Harvey"),
    last_name = c("Spector"))
  result <- cran_all_pubs(cran_authors)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})

test_that("cran_all_pubs returns distinct rows", {
  cran_authors <- tibble::tibble(
    first_name = c("Michael", "Michael"),
    last_name = c("Lydeamore", "Lydeamore"))
  result <- cran_all_pubs(cran_authors)
  expect_s3_class(result, "tbl_df")
  expect_true(nrow(result) == nrow(dplyr::distinct(result)))
})

test_that("cran_all_pubs returns an empty dataframe if no authors are provided", {
  cran_authors <- tibble::tibble(first_name = character(0), last_name = character(0))
  result <- cran_all_pubs(cran_authors)
  expect_s3_class(result, "tbl_df")
  expect_equal(nrow(result), 0)
})



