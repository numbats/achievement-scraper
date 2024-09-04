#' 1. get_publications
#'
#' @description
#' This function retrieves research publications from Google Scholar and ORCID based on the provided IDs.
#' It fetches publications from each platform and combines them into a unified dataset. .
#'
#' @param orcid_id ORCID ID
#' @param scholar_id Google Scholar ID
#'
#' @return A dataframe containing research outputs: title, DOI, authors, publication_date, and journal_name
#'
#' @examples
#' # Example 1: Retrieve publications from both ORCID and Google Scholar
#' \dontrun{get_publications("0000-0003-2531-9408", "Gcz8Ng0AAAAJ")}
#'
#  # Example 2: Retrieve publications only from Google Scholar
#' \dontrun{get_publications(NA, "Gcz8Ng0AAAAJ")}
#'
#' # Example 3: Retrieve publications only from ORCID
#' \dontrun{get_publications("0000-0003-2531-9408", NA)}
#'
#' @name get_publications
#'
#' @export
get_publications <- function(orcid_id, scholar_id) {
  # publications from Google Scholar
  if (is.na(scholar_id)) {
    scholar_pubs <- NULL
  } else {
    scholar_pubs <- get_publications_from_scholar(scholar_id)
  }

  # publications from ORCID
  if (is.na(orcid_id)) {
    orcid_pubs <- NULL
  } else {
    orcid_pubs <- get_publications_from_orcid(orcid_id)
  }

  # Combine and deduplicate
  all_pubs <- dplyr::bind_rows(scholar_pubs, orcid_pubs) |>
    dplyr::distinct()

  # Split into research frame
  research_df <- all_pubs |>
    dplyr::filter(!is.na(journal_name)) |>
    dplyr::select(title, DOI, authors, publication_date, journal_name)

  # Return the research dataframe
  return(research_df)
}


# 2. Function to combine outputs from `get_publications` for multiple people
#'
#' @param ids A list of ORCID and Scholar IDs for multiple people
#' @return A combined dataframe of research outputs for all people
#' @export
combine_publications_for_multiple <- function(ids) {
  combined_df <- purrr::map_dfr(ids, function(id) {
    get_publications(id$orcid_id, id$scholar_id)
  })

  # Deduplicate combined results
  combined_df <- combined_df |>
    dplyr::distinct()

  return(combined_df)
}

# 3. Function to combine CRAN downloads for multiple people
#'
#' @param people A list of first and last names for multiple people
#' @return A combined dataframe of CRAN package downloads for all people
#' @export
combine_cran_for_multiple <- function(people) {
  combined_df <- purrr::map_dfr(people, function(person) {
    find_cran_packages(person$first_name, person$last_name)
  })

  # Deduplicate combined results
  combined_df <- combined_df |>
    dplyr::distinct()

  return(combined_df)
}
