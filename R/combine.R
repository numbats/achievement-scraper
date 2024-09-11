#' get_publications
#'
#' @description
#' This function retrieves research publications from Google Scholar and ORCID based on the provided IDs.

#' @param orcid_id ORCID ID
#' @param scholar_id Google Scholar ID
#'
#' #' @return A dataframe containing research outputs containing title, DOI, authors, publications, journal name.
#'
#' @examples
#' # Example 1: Retrieve publications from both ORCID and Google Scholar
#' \dontrun{get_publications("0000-0002-2140-5352", "vamErfkAAAAJ")}
#'
#  # Example 2: Retrieve publications only from Google Scholar
#' \dontrun{get_publications(NA, "vamErfkAAAAJ")}
#'
#' # Example 3: Retrieve publications only from ORCID
#' \dontrun{get_publications("0000-0002-2140-5352", NA)}
#'
#' @name get_publications
#' @export
get_publications <- function(orcid_id, scholar_id) {
  if (is.na(scholar_id)) {
    scholar_pubs <- NULL
  } else {
    scholar_pubs <- get_publications_from_scholar(scholar_id)
  }

  if (is.na(orcid_id)) {
    orcid_pubs <- NULL
  } else {
    orcid_pubs <- get_publications_from_orcid(orcid_id)
  }

  all_pubs <- dplyr::bind_rows(scholar_pubs, orcid_pubs) |>
    dplyr::distinct()

  required_cols <- c("title", "DOI", "authors", "publication_year", "journal_name")
  missing_cols <- setdiff(required_cols, colnames(all_pubs))

  if (length(missing_cols) > 0) {
    for (col in missing_cols) {
      all_pubs[[col]] <- NA
    }
  }

  research_df <- all_pubs |>
    dplyr::filter(!is.na(journal_name)) |>
    dplyr::select(title, DOI, authors, publication_year, journal_name)

  return(tibble::as_tibble(research_df))
}





#' get_all_publications
#'
#' @description
#' This function retrieves research publications of all the authors from
#' Google Scholar and ORCID based on the provided IDs.
#'
#' @param authors_df A dataframe containing columns `orcid_id` and `scholar_id`
#'                   for each author.
#' @return A combined dataframe of research outputs for all authors' publications.
#' @examples
#' \dontrun{
#' authors_df <- tibble::tibble(
#'   orcid_id = c("0000-0002-2140-5352", "0000-0002-1825-0097", NA, "0000-0001-5109-3700"),
#'   scholar_id = c(NA, "vamErfkAAAAJ", "4bahYMkAAAAJ", NA)
#' )
#' get_all_publications(authors_df)
#' }
#' @name get_all_publications
#' @export
get_all_publications <- function(authors_df) {
  combined_pubs <- list()

  for (i in seq_along(authors_df$orcid_id)) {
    orcid_id <- authors_df$orcid_id[i]
    scholar_id <- authors_df$scholar_id[i]

    multiple_pubs <- get_publications(orcid_id, scholar_id)

    combined_pubs[[i]] <- multiple_pubs
  }

  return(tibble::as_tibble(dplyr::bind_rows(combined_pubs)))
}





#' cran_all_pubs
#'
#' @description
#' This function combines the cran publications for all authors.
#'
#' @param author A list of names of different authors.
#' @return A combined dataframe of CRAN package downloads for all authors.
#' @examples
#' \dontrun{
#' cran_authors <- tibble::tibble(
#'   first_name = c("Michael", "Rob"),
#'   last_name = c("Lydeamore", "Hyndman")
#' )
#' }

#' \dontrun{cran_all_pubs(cran_authors)}
#'
#' @name cran_all_pubs
#' @export
cran_all_pubs <- function(authors) {
  combined_df <- purrr::map_dfr(1:nrow(authors), function(i) {
    find_cran_packages(authors$first_name[i], authors$last_name[i])
  })

  combined_df <- combined_df |>
    dplyr::distinct()

  return(tibble::as_tibble(combined_df))
}

