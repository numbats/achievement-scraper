#' Get Publications from Google Scholar and ORCID
#'
#' @param orcid_id ORCID ID
#' @param scholar_id Google Scholar ID
#' @return A tibble of combined and de-duplicated publications
#' @export
get_publications <- function(orcid_id, scholar_id) {
  # Get publications from Google Scholar
  scholar_pubs <- get_publications_from_scholar(scholar_id)

  # Get publications from ORCID
  orcid_pubs <- get_publications_from_orcid(orcid_id)

  # Combine the two data frames
  all_pubs <- dplyr::bind_rows(scholar_pubs, orcid_pubs)

  # De-duplicate the combined data
  unique_pubs <- dplyr::distinct(all_pubs)

  return(unique_pubs)
}
