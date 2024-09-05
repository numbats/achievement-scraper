#' 1. get_publications
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
#'
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
    dplyr::select(title, DOI, authors, publication_date, journal_name)

  return(research_df)
}





#' 2. get_all_publications
#'
#' @description
#' This function retrieves research publications of all the authors from
#' Google Scholar and ORCID based on the provided IDs.

#' @param orcid_id list of ORCID ID
#' @param scholar_id list of Google Scholar ID
#' @return A combined dataframe of research outputs for all authors publications.
#' @examples
#' \dontrun{orcid_ids <- c("0000-0002-2140-5352", "0000-0002-1825-0097", NA, "0000-0001-5109-3700")}
#' \dontrun{scholar_ids <- c(NA, "vamErfkAAAAJ", "4bahYMkAAAAJ", NA)}
#' \dontrun{get_all_publications(orcid_ids, scholar_ids)}
#'
#' @name get_all_publications
#'
#' @export
get_all_publications <- function(orcid_ids, scholar_ids) {
  combined_pubs <- list()

  for (i in seq_along(orcid_ids)) {
    orcid_id <- orcid_ids[i]
    scholar_id <- scholar_ids[i]

    multiple_pubs <- get_publications(orcid_id, scholar_id) |>
      dplyr::mutate(
        DOI = purrr::map(
          .x = DOI,
          .f = function(x) {
            dplyr::filter(x, `external-id-type` == "doi") |>
              dplyr::pull(`external-id-value`)
          }
        )
      )

    combined_pubs[[i]] <- multiple_pubs
  }

  return(dplyr::bind_rows(combined_pubs))
}





#' 3. cran_all_pubs
#'
#' @description
#' This function combines the cran publications for all authors.
#'
#' @param author A list of names of different authors.
#' @return A combined dataframe of CRAN package downloads for all authors.
#' @examples
#' \dontrun{
  #' authors_list <- list(
  #'   list(first_name = "Michael", last_name = "Lydeamore"),
  #'   list(first_name = "Rob", last_name = "Hyndman")
  #' )
  #' }
  #' \dontrun{cran_all_pubs(authors_list)}
  #' @name cran_all_pubs
#' @export
cran_all_pubs <- function(authors) {
  combined_df <- purrr::map_dfr(authors, function(person) {
    find_cran_packages(person$first_name, person$last_name)
  })

  combined_df <- combined_df |>
    dplyr::distinct()

  return(combined_df)
}

