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
