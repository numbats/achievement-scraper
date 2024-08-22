#' Get Publications from ORCID
#'
#' @param orcid_id ORCID ID
#' @return A tibble of publications from ORCID
#' @export
get_publications_from_orcid <- function(orcid_id) {
  # This function is a placeholder.
  orcid_pubs <- tibble::tibble(
    title = c("Sample Title 1", "Sample Title 2"),
    DOI = c("10.1234/example1", "10.1234/example2"),
    authors = c("Author One, Author Two", "Author Three, Author Four"),
    publication_date = as.Date(c("2020-01-01", "2021-02-01")),
    journal_name = c("Journal A", "Journal B"),
    software_name = c(NA, "Software X"),
    num_downloads = c(NA, 1000),
    last_update_date = as.Date(c(NA, "2022-05-01")),
    original_publish_date = as.Date(c(NA, "2021-01-01"))
  )

  return(orcid_pubs)
}
