# Reading the data 
orcid_gsid <- readr::read_csv("data-raw/orcid_gsid.csv")
# Documenting the data
usethis::use_data(orcid_gsid, overwrite = T)