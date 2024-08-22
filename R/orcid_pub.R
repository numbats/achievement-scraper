# Read the CSV file and extract ORCID IDs
orcid_data <- readr::read_csv("data-raw/orcid_gsid.csv")
orcid_ids <- orcid_data %>%
  filter(!is.na(orcid_id))%>%
  pull(orcid_id)

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

