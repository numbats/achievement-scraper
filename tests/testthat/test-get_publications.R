test_that("get_publications works correctly", {
  scholar_id <- "Gcz8Ng0AAAAJ"
  orcid_id <- "0000-0001-2345-6789"

  results <- get_publications(orcid_id, scholar_id)

  expect_type(results, "list")
  expect_named(results, c("research", "software"))
  expect_true(nrow(results$research) > 0)
  expect_true(nrow(results$software) > 0)
})
