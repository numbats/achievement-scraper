#' get_publications_from_orcid
#'
#' @description
#' The `get_publications_from_orcid` function retrieves publications for given ORCID IDs using the rorcid package.
#' It fetches all works associated with each ORCID ID and combines them into a single data frame.
#'
#' @param orcid_ids A character vector of ORCID IDs for which publication information is requested.
#'
#' @return A data frame containing all publications for the specified ORCID IDs.
#'
#' @importFrom rorcid orcid_works
#' @importFrom dplyr select bind_rows
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#'
#' @examples
#' # Retrieve publications for specific ORCID IDs
#' get_publications_from_orcid(c("0000-000X-XXXX-XXXX", "0000-000X-XXXX-XXXX"))
#'
#' @name get_publications_from_orcid
#' @export

get_publications_from_orcid <- function(orcid_ids) {
  all_pubs <- list()

  for (orcid_id in orcid_ids) {
    pubs <- rorcid::orcid_works(orcid_id)
    if (!is.null(pubs[[1]]$works)) {
      all_pubs[[orcid_id]] <- pubs[[1]]$works %>%
        dplyr::select(
          title = .data[[ "work-title" ]][[ "title" ]][[ "value" ]],
          DOI = .data[[ "work-external-identifiers" ]][[ "work-external-identifier" ]][[1]][[ "work-external-identifier-id" ]][[ "value" ]],
          authors = .data[[ "work-contributors" ]][[ "contributor" ]][[1]][[ "credit-name" ]][[ "value" ]],
          publication_date = .data[[ "publication-date" ]][[ "year" ]][[ "value" ]],
          journal_name = .data[[ "journal-title" ]][[ "value" ]]
        )
    } else {
      all_pubs[[orcid_id]] <- tibble::tibble()
    }
  }

  return(dplyr::bind_rows(all_pubs, .id = "orcid_id"))
}

