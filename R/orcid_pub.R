library(rorcid)
library(tidyverse)

fetch_orcid_publications <- function(orcid_ids) {
  # Initialize an empty list to store publications
  all_pubs <- list()

  # Loop over each ORCID ID to fetch their works
  for (orcid_id in orcid_ids) {
    pubs <- orcid_works(orcid_id)
    all_pubs[[orcid_id]] <- pubs[[1]]$works
  }

  all_pubs <- bind_rows(all_pubs)

  # Print the publications for each ORCID ID
  print(all_pubs)
}

# To use the function, provide the ORCID IDs when calling it:
# fetch_orcid_publications(orcid_ids)

get_publications_from_orcid()

