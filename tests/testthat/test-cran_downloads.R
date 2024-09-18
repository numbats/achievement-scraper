test_that("find_cran_packages returns a dataframe", {
  result <- find_cran_packages("Michael", "Lydeamore")
  expect_s3_class(result, "tbl_df")
  expect_true(all(c("name", "downloads", "authors", "last_update_date") %in% names(result)))
})

test_that("find_cran_packages returns an author", {
  result <- find_cran_packages("Michael", "Lydeamore")
  expect_gt(nrow(result), 0)
})

test_that("find_cran_packages gives correct author", {
  result <- find_cran_packages("Rob", "Hyndman")
  expect_true(all(grepl("Rob Hyndman", result$authors)))
})

test_that("find_cran_packages handles unknown author", {
  result <- find_cran_packages("Harvey", "Spector")
  expect_equal(nrow(result), 0)
})

test_that("find_cran_packages returns the correct year", {
  result <- find_cran_packages("Michael", "Lydeamore")
  expect_true("last_update_date" %in% names(result))
  years <- format(as.Date(result$last_update_date), "%Y")
  expect_true(all(!is.na(years)))
})
