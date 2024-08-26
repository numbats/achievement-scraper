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
#' @examples
#' # Retrieve publications for specific ORCID IDs
#' get_publications_from_orcid(c("0000-0002-1825-0097", "0000-0003-1825-0098"))
#'
#' @rdname get_publications_from_orcid
#'
#' @export

library(rorcid)
library(dplyr)

get_publications_from_orcid <- function(orcid_ids) {
  # Initialize an empty list to store publications
  all_pubs <- list()

  # Loop over each ORCID ID to fetch their works
  for (orcid_id in orcid_ids) {
    pubs <- orcid_works(orcid_id)
    if (!is.null(pubs[[1]]$works)) {
      all_pubs[[orcid_id]] <- pubs[[1]]$works %>%
        dplyr::select(
          title = `work-title`$title$value,
          DOI = `work-external-identifiers`$`work-external-identifier`[[1]]$`work-external-identifier-id`$value,
          authors = `work-contributors`$`contributor`[[1]]$`credit-name`$value,
          publication_date = `publication-date`$year$value,
          journal_name = `journal-title`$value
        )
    } else {
      all_pubs[[orcid_id]] <- tibble()
    }
  }

  # Combine all publications into a single data frame
  return(bind_rows(all_pubs, .id = "orcid_id"))
}

