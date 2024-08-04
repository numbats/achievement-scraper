library(tidyverse)
library(kableExtra)
library(tsibble)
library(lubridate)
library(pkgmeta)
library(pkgsearch)
library(cranlogs)

# Find CRAN packages with author containing <name>
find_cran_packages <- function(name) {
  pkgsearch::ps(name, size = 100) |>
    filter(purrr::map_lgl(
      package_data, ~ grepl(name, .x$Author, fixed = TRUE)
    )) |>
    select(package) |>
    pull(package)
}

# Monthly download counts from packages in <x>
cran_downloads <- function(x) {
  # Compute monthly download counts
  down <- cranlogs::cran_downloads(x, from = "2000-01-01") |>
    as_tibble() |>
    mutate(month = tsibble::yearmonth(date)) |>
    group_by(month) |>
    summarise(count = sum(count), package = x)
  # Strip out initial zeros
  first_nonzero <- down |>
    filter(count > 0) |>
    head(1)
  if (NROW(first_nonzero) > 0) {
    filter(down, month >= first_nonzero$month)
  } else {
    first_nonzero
  }
}

# Clean up author list from CRAN meta data
clean_authors <- function(x) {
  # Fix weird characters
  x <- gsub("<U+000a>", " ", x)
  # Add J to my name
  x <- gsub("Rob Hyndman", "Rob J Hyndman", x)
  # Fix Souhaib's name
  x <- gsub("Ben Taieb", "{Ben~Taieb}", x)
  # Replace R Core Team with {R Core Team}
  x <- gsub("R Core Team", "{R Core Team}", x)
  # Replace AEC
  x <- gsub("Commonwealth of Australia AEC", "{Commonwealth of Australia AEC}", x)
  # Replace ABS
  x <- gsub("Australian Bureau of Statistics ABS", "{Australian Bureau of Statistics ABS}", x)
  # Remove comments in author fields
  x <- gsub("\\([a-zA-Z0-9\\-\\s,&\\(\\)<>:/\\.']*\\)", " ", x, perl = TRUE)
  # Remove email addresses
  x <- gsub("<[a-zA-Z@.]*>", "", x, perl = TRUE)
  # Remove contribution classification
  x <- gsub("\\[[a-zA-Z, ]*\\]", "", x, perl = TRUE)
  # Remove github handles
  x <- gsub("\\([@a-zA-Z0-9\\-]*\\)", "", x, perl = TRUE)
  # Replace line breaks with "and"
  x <- gsub("\\n", " and ", x)
  # Replace commas with "and"
  x <- gsub(",", " and ", x)
  # Trim spaces
  x <- trimws(x)
  x <- gsub("  +", " ", x, perl = TRUE)
  # Remove duplicate ands
  x <- gsub("and and and ", "and ", x, perl = TRUE)
  x <- gsub("and and ", "and ", x, perl = TRUE)
  return(x)
}

keep_monash_authors <- function(x) {
  authors <- strsplit(x, " and ")
  monash_authors <- c(
    "Rob Hyndman", "Rob J Hyndman",
    "Dianne Cook", "Di Cook",
    "Emi Tanaka",
    "Mitchell O'Hara-Wild", "Mitch O'Hara-Wild",
    "Yangzhuoran Yang", "Yangzhuoran Fin Yang",
    "George Athanasopoulos",
    "Fan Cheng",
    "Patricia Menendez", "Patricia Menéndez",
    "Lauren Kennedy",
    "Nick Spyrison", "Nicholas Spyrison",
    "Sherry Zhang", "H. Sherry Zhang",
    "Michael Lydeamore",
    "Ryan Thompson"
  )
  authors <- lapply(authors, function(x) {
    x[x %in% monash_authors]
  })
  authors <- lapply(authors, function(x) {
    paste0(x, "", collapse = ", ")
  })
  return(unlist(authors))
}

clean_description <- function(x) {
  # Clean up as for authors
  # Add J to my name
  x <- gsub("Rob Hyndman", "Rob J Hyndman", x)
  # Remove line breaks
  x <- gsub("\\n", " ", x)
  # Trim spaces
  x <- trimws(x)
  # Find arXiv links
  x <- gsub("arXiv:", "https://arxiv.org/abs/", x, perl = TRUE)
  # Find doi links
  x <- gsub("doi:", "https://doi.org/", x, perl = TRUE)
  x <- gsub("DOI:", "https://doi.org/", x, perl = TRUE)
  # Fix weird characters
  x <- gsub("<U+000a>", " ", x, fixed=TRUE)
  return(x)
}

# Return CRAN packages with EBS authors
packages <- c(
  find_cran_packages("Hyndman"),
  find_cran_packages("Di Cook"),
  find_cran_packages("Dianne Cook"),
  find_cran_packages("Emi Tanaka"),
  find_cran_packages("Patricia Menendez"),
  find_cran_packages("Patricia Menéndez"),
  find_cran_packages("Lauren Kennedy"),
  find_cran_packages("O'Hara-Wild"),
  find_cran_packages("Spyrison"),
  find_cran_packages("Sherry Zhang"),
  find_cran_packages("Lydeamore"),
  find_cran_packages("Yangzhuoran"),
  "grpsel","familial", # From Ryan Thompson
  NULL
) |>
  unique() |>
  sort()


# Packages updated or released in 2021
meta <- pkgmeta:::get_meta_cran(packages, include_downloads=TRUE, start="2014-01-01") |>
  rename(released = first_download, last_update = date)

# Get download data
downloads <- map_dfr(meta$package, cran_downloads) |>
  mutate(month = tsibble::yearmonth(month)) |>
  as_tsibble(index=month, key=package)

downloads <- downloads |>
  as_tibble() |>
  filter(lubridate::year(month) >= 2021) |>
  group_by(package) |>
  summarise(count = sum(count)) |>
  mutate(monthly_ave = round(count / 12)) |>
  rename(count_2021 = count, monthly_ave_2021 = monthly_ave) |>
  left_join(
    downloads |>
      as_tibble() |>
      filter(lubridate::year(month) >= 2016) |>
      group_by(package) |>
      summarise(count = sum(count)) |>
      rename(count_2016 = count)
  ) |>
  left_join(
    downloads |>
      as_tibble() |>
      group_by(package) |>
      summarise(count = sum(count))
  ) |>
  select(package, count, count_2016, count_2021, monthly_ave_2021)

ebs_website <- meta |>
  #filter(year(released) < 2021, last_update > "2021-01-01") |>
  left_join(downloads) |>
  arrange(desc(monthly_ave_2021)) |>
  filter(monthly_ave_2021 > 5000) |>
  # Remove ctb only packages
  filter(!package %in% c("rmarkdown","DescTools","fracdiff","xaringan","visdat")) |>
  mutate(title = paste0(package,": ",title)) |>
  select(title, description, authors, monthly_ave_2021) |>
  mutate(
    authors = clean_authors(authors),
    authors = keep_monash_authors(authors),
    description = clean_description(description)
  )

