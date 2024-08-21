#' Get Publications from Google Scholar
#'
#' @param scholar_id Google Scholar ID
#' @return A tibble of publications from Google Scholar
#' @export
get_publications_from_scholar <- function(scholar_id) {
  publications <- scholar::get_publications(scholar_id)

  # Check if the column exists, if not, create a placeholder
  if (!"doi" %in% colnames(publications)) {
    publications$doi <- NA
  }

  # Ensure other columns exist
  if (!"journal" %in% colnames(publications)) {
    publications$journal <- NA
  }
  if (!"pub_date" %in% colnames(publications)) {
    publications$pub_date <- NA
  }

  # required research frame structure
  scholar_df <- publications %>%
    dplyr::select(
      title = title,
      DOI = doi,
      authors = author,
      publication_date = pub_date,
      journal_name = journal
    )

  return(scholar_df)
}
