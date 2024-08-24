# Reading the data
orcid_gsid <- readr::read_csv("data-raw/orcid_gsid.csv")
# Document the data
usethis::use_data(orcid_gsid, overwrite = T)
# Saving the data
save(orcid_gsid, file = "data/orcid_gsid.rda")


