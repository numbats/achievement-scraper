#' Get Publications from Google Scholar and ORCID
#'
#' @param orcid_id ORCID ID
#' @param scholar_id Google Scholar ID
#' @return A list containing two dataframes: one for research outputs and one for software metadata
#' @export
get_publications <- function(orcid_id, scholar_id) {
  # publications from Google Scholar
  scholar_pubs <- get_publications_from_scholar(scholar_id)

  # publications from ORCID
  orcid_pubs <- get_publications_from_orcid(orcid_id)

  # Combine and deduplicate
  all_pubs <- dplyr::bind_rows(scholar_pubs, orcid_pubs) |>
    dplyr::distinct()

  # Split into research and software frames
  research_df <- all_pubs |>
    dplyr::filter(!is.na(journal_name)) |>
    dplyr::select(title, DOI, authors, publication_date, journal_name)

  software_df <- all_pubs |>
    dplyr::filter(!is.na(software_name)) |>
    dplyr::select(software_name, authors, num_downloads, last_update_date, original_publish_date)

  # Return the dataframes as a list
  return(list(research = research_df, software = software_df))
}
