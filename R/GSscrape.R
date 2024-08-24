#All articles per year, including their links
#Summarised articles by author, journals, and rankings
#For each staff member: h-index, total citations, top 10 cited outputs
#Package name, number of downloads, date of last update

library(scholar)
library(dplyr)

nonna_scholars <- orcid_gsid |>
  filter(!is.na(gsuser_id))

all_pubs <- lapply(nonna_scholars$gsuser_id, function(scholar_id) {
  get_publications_from_scholar(scholar_id = scholar_id)
}) |> bind_rows()

for (scholar_id in nonna_scholars$gsuser_id) {
  get_publications_from_scholar(scholar_id = scholar_id)
}


