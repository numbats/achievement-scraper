#' Appends column to tibble if it doesn't exist
#' 
#' @param .data Input data frame
#' @param column Column to test (unquoted)
#' @param default_value Value to put in column if it doesn't exist
#' 
#' @return `.data` with the missing column added
append_column_if_missing <- function(.data, column, default_value = NA) {

  current_columns <- colnames(.data)

  if (!column %in% current_columns) {
    return(
      .data |>
        mutate(!!column := default_value)
    )
  }

  return (.data)
}