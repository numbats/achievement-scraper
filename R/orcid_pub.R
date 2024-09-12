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
#' @importFrom dplyr select bind_rows mutate
#' @importFrom tibble tibble
#' @importFrom magrittr %>%
#'
#' @examples
#' \dontrun{get_publications_from_orcid(c("0000-0003-2531-9408", "0000-0001-5738-1471"))}
#'
#' @name get_publications_from_orcid
#' @export

get_publications_from_orcid <- function(orcid_ids) {
  orcid_ids <- as.vector(orcid_ids)
  all_pubs <- list()

  for (orcid_id in orcid_ids) {
    pubs <- tryCatch(
      rorcid::orcid_works(orcid_id),
      error = function(e) {
        if (inherits(e, "http_404")) {
          stop(sprintf("Invalid ORCID ID: %s", orcid_id))
        } else {
          print(e)
        }
      }
    )
    if (!is.null(pubs[[1]]$works) && nrow(pubs[[1]]$works > 0)) {
      all_pubs[[orcid_id]] <- pubs[[1]]$works %>%
        dplyr::select(
          title = `title.title.value`,
          DOI = `external-ids.external-id`,
          authors = `source.assertion-origin-name.value`,
          publication_year = `publication-date.year.value`,
          journal_name = `journal-title.value`
        ) |>
        mutate(
          # the `external-ids` contains lots of things, not just DOI. It is a list containing a dataframe
          # Mapping over that list, we can filter out just the 'doi' type
          # Then pull it into a character vector
          # Overwrite DOI with this value
          DOI = purrr::map_chr(
            .x = DOI,
            .f = function(x) {
              if(length(x) == 0L)
                return(NA)
              doi <- dplyr::filter(x, `external-id-type` == "doi") |>
                dplyr::pull(`external-id-value`)

              if (length(doi) == 0L) {
                return (NA)
              } else {
                return (doi[1])
              }
            }
          ),
          orcid_id = orcid_id,
          publication_year = as.numeric(publication_year)
        )
    }
  }

  return(dplyr::bind_rows(all_pubs))
}




