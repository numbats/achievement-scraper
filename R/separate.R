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
    if (!is.null(pubs[[1]]$works) && nrow(pubs[[1]]$works) > 0) {
      all_pubs[[orcid_id]] <- pubs[[1]]$works |>
        dplyr::select(
          title = dplyr::matches("title.title.value"),
          DOI = dplyr::matches("external-ids.external-id"),
          authors = dplyr::matches("source.assertion-origin-name.value"),
          publication_year = dplyr::matches("publication-date.year.value"),
          journal_name = dplyr::matches("journal-title.value")
        ) |>
        append_column_if_missing("title", default_value = NA_character_) |>
        append_column_if_missing("DOI", default_value = NA_character_) |>
        append_column_if_missing("authors", default_value = NA_character_) |>
        append_column_if_missing("publication_year", default_value = NA_integer_) |>
        append_column_if_missing("journal_name", default_value = NA_character_) |>
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

  if (length(scholar_id) == 0) {
    return(tibble::tibble(
      title = character(0),
      DOI = character(0),
      authors = character(0),
      publication_year = integer(0),
      journal_name = character(0)
    ))
  }

  publications <- scholar::get_publications(scholar_id)

  if (!"doi" %in% colnames(publications)) {
    publications$doi <- NA_character_
  }

  if (!"journal" %in% colnames(publications)) {
    publications$journal <- NA_character_
  }
  if (!"year" %in% colnames(publications)) {
    publications$year <- NA_integer_
  }

  scholar_tbl <- tibble::tibble(
    title = publications$title,
    DOI = publications$doi,
    authors = publications$author,
    publication_year = as.integer(publications$year),
    journal_name = publications$journal
  )

  return(tibble::as_tibble(scholar_tbl))
}




#' find_cran_packages
#'
#' @description
#' This function searches for CRAN packages by a given author's first and last name.
#'
#' @param first_name A character string representing the author's first name.
#' @param last_name A character string representing the author's last name.
#'
#' @return A data frame returning package name, number of downloads,author names and last update date of the package.
#'
#' @importFrom pkgsearch ps
#' @importFrom tibble tibble
#' @importFrom dplyr bind_rows filter
#' @importFrom stringr str_detect
#'
#' @examples
#' \dontrun{find_cran_packages("Michael", "Lydeamore")}
#'
#' @name find_cran_packages
#' @export

find_cran_packages <- function(first_name, last_name) {

  author_name <- paste(first_name, last_name)

  results <- pkgsearch::ps(author_name, size = 200)

  num_packages <- length(results$package)

  if (num_packages == 0) {
    return(
      tibble::tibble(
        name = character(0),
        downloads = numeric(0),
        authors = character(0),
        last_update_date = character(0)
      )
    )
  }

  package_frame <- lapply(1:num_packages, function(i) {

    tibble(
      name = results$package[i],
      downloads = results$package_data[[i]]$downloads,
      authors = results$package_data[[i]]$Author,
      last_update_date = results$package_data[[i]]$date
    )
  }) |>
    dplyr::bind_rows() |>
    dplyr::filter(stringr::str_detect(authors, author_name))

  unique(package_frame)
}


