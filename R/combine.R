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
    multiple_pubs$lookup_name <- paste(authors_df$first_name[i], authors_df$last_name[i])

    combined_pubs[[i]] <- multiple_pubs
  }

  nr <- lapply(combined_pubs, NROW)
  combined_pubs <- combined_pubs[nr > 0]

  return(tibble::as_tibble(dplyr::bind_rows(combined_pubs)))
}





#' cran_all_pubs
#'
#' @description
#' This function combines the cran publications for all authors.
#'
#' @param authors A list of names of different authors.
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
  if (nrow(authors) == 0) {
    return(tibble::tibble(name = character(), downloads = numeric(), authors = character(), last_update_date = character()))
  }

  combined_df <- purrr::map_dfr(1:nrow(authors), function(i) {
    find_cran_packages(authors$first_name[i], authors$last_name[i])
  })

  combined_df <- combined_df |>
    dplyr::distinct()

  return(tibble::as_tibble(combined_df))
}
