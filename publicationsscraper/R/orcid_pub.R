# function to scrape ORCID
get_publications_from_orcid <- function(orcid_id) {
  # Will replace this with actual scraping
  # For now, we'll return a dummy tibble with some placeholder data

  orcid_pubs <- tibble::tibble(
    title = c("ORCID Publication 1", "ORCID Publication 2"),
    authors = c("Author X, Author Y", "Author Z, Author W"),
    journal = c("Journal X", "Journal Y"),
    year = c(2019, 2022),
    source = "ORCID"
  )

  return(orcid_pubs)
}
