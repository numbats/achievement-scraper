library(readr)

# Function to search by ORCID ID
#' Search by ORCID ID
#'
#' @param orcid_id 
#' @return 
#' @export
search_by_orcid <- function(orcid_id) {
  data <- read_csv("orcid_gsid.csv")
  result <- data[data$orcid_id == orcid_id, ]
  return(result)
}

# Function to search by Google Scholar ID
#' Search by Google Scholar ID
#'
#' @param gsid 
#' @return 
#' @export
search_by_gsid <- function(gsid) {
  data <- read_csv("orcid_gsid.csv")
  result <- data[data$gsuser_id == gsid, ]
  return(result)
}

# Function to search by Name
#' Search by Name
#'
#' @param first_name 
#' @param last_name 
#' @return 
#' @export
search_by_name <- function(first_name, last_name) {
  data <- read_csv("orcid_gsid.csv")
  result <- data[data$first_name == first_name & data$last_name == last_name, ]
  return(result)
}

