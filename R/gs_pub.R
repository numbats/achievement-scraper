#' get_publications_from_scholar
#'
#' @description
#' This function retrieves publications for a given Google Scholar ID and formats them into a structured tibble.
#'
#' @param scholar_id A character string representing the Google Scholar ID.
#'
#' @return A tibble containing all publications for the specified Google Scholar ID.
#'
#' @importFrom scholar get_publications
#' @importFrom dplyr select
#' @importFrom tibble tibble
#'
#' @examples
#' \dontrun{get_publications_from_scholar("vamErfkAAAAJ")}
#' @name get_publications_from_scholar
#' @export
get_publications_from_scholar <- function(scholar_id) {
  publications <- scholar::get_publications(scholar_id)

  # See if the column exists, if not, create a placeholder
  if (!"doi" %in% colnames(publications)) {
    publications$doi <- NA_character_
  }

  # Make sure other columns exist
  if (!"journal" %in% colnames(publications)) {
    publications$journal <- NA_character_
  }
  if (!"year" %in% colnames(publications)) {
    publications$year <- NA_integer_
  }

  # data as a tibble
  scholar_tbl <- tibble::tibble(
    title = publications$title,
    DOI = publications$doi,
    authors = publications$author,
    publication_year = publications$year,
    journal_name = publications$journal
  )

  return(tibble::as_tibble(scholar_tbl))
}

