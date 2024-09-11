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

  # Assuming there are columns 'first_name' and 'last_name' in the CSV
  author_name <- paste(first_name, last_name)

  # Loop through names and find packages
    results <- pkgsearch::ps(author_name, size = 200)

    num_packages <- length(results$package)

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

  # Return unique packages only
  unique(package_frame)
}
