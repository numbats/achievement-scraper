#As per George:

#All articles per year, including their links
#Summarised articles by author, journals, and rankings
#For each staff member: h-index, total citations, top 10 cited outputs
#Package name, number of downloads, date of last update
#We can aim to have two dataframes: One for research outputs and one for software.

#Software frame

#software_name
#authors
#num_downloads
#last_update_date
#original_publish_date (if available)



library(tidyverse)
library(kableExtra)
library(tsibble)
library(lubridate)
library(pkgmeta)
library(pkgsearch)
library(cranlogs)

find_cran_packages <- function() {
  # Load the ORCID names
  orcid_gsid <- read_csv("data-raw/orcid_gsid.csv")

  # Assuming there are columns 'first_name' and 'last_name' in the CSV
  names_to_search <- paste(orcid_gsid$first_name, orcid_gsid$last_name)

  # Prepare a vector to store all found packages
  all_packages <- c()

  # Loop through names and find packages
  for (name in names_to_search) {
    results <- pkgsearch::ps(name, size = 100)
    author_packages <- results$data %>%
      filter(grepl(name, Author, fixed = TRUE)) %>%
      pull(package)

    # Combine the results into the main vector
    all_packages <- c(all_packages, author_packages)
  }

  # Return unique packages only
  unique(all_packages)
}


