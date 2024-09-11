#' get_publications_from_scholar
#'
#' @description
#' This function retrieves publications for a given Google Scholar ID and formats them into a structured data frame.
#'
#' @param scholar_id A character string representing the Google Scholar ID.
#'
#' @return A data frame containing all publications for the specified Google Scholar ID.
#'
#' @importFrom scholar get_publications
#' @importFrom dplyr select
#'
#' @examples
#' \dontrun{get_publications_from_scholar("vamErfkAAAAJ")}
#' @name get_publications_from_scholar
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
      publication_year = pub_date,
      journal_name = journal
    )

  return(scholar_df)
}

