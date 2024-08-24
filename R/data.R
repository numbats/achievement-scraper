#' orcid_gsid
#'
#' This dataset contains the mappings between researcher names and their respective ORCID
#' and Google Scholar IDs. It is useful for identifying and linking academic profiles across
#' different platforms.
#'
#' @format A data frame with 4 variables:
#' \describe{
#'  \item{first_name}{\code{character}. The first name of the individual.}
#'  \item{last_name}{\code{character}. The last name of the individual.}
#'  \item{orcid_id}{\code{character}. The ORCID identifier.}
#'  \item{gsuser_id}{\code{character}. The Google Scholar user ID.}
#' }
#' @source \url{https://www.monash.edu/business/ebs/our-people/staff-directory}
"orcid_gsid"
