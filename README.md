
<!-- README.md is generated from README.Rmd. Please edit that file -->

# publicationsscraper

<!-- badges: start -->
<!-- badges: end -->

# Research and CRAN Publications Retrieval Package

## Overview

The `publicationsscraper` R package offers tools to retrieve research
publications from Google Scholar and ORCID, along with CRAN package
download statistics. It is tailored for academic researchers in the EBS
department who wish to consolidate and analyze their research outputs,
while also monitoring their contributions to CRAN, including publication
updates and downloads.

The main functions included are: - `find_cran_packages`: Searches for
CRAN packages by an author’s first and last name and returns relevant
package information such as the number of downloads and last update
date. - `get_publications`: Retrieves publications from both Google
Scholar and ORCID based on provided IDs. - `get_all_publications`:
Retrieves publications from multiple authors. - `cran_all_pubs`:
Combines CRAN package data for multiple authors.

## Installation

To install this package, you can clone the repository and load the
package using:

``` r
# Clone the repository
git clone <https://github.com/numbats/achievement-scraper.git>

# Install required packages
install.packages(c("pkgsearch", "tibble", "dplyr", "stringr", "scholar", "rorcid"))

# Load the package
devtools::load_all()
```

## Functions

## 1. `find_cran_packages`

This function retrieves information about CRAN packages authored by a
specified individual. It returns a data frame containing the package
name, number of downloads, the authors, and the last update date.

``` r
library(publicationsscraper)
find_cran_packages("Michael", "Lydeamore")
#> # A tibble: 4 × 4
#>   name            downloads authors                             last_update_date
#>   <chr>               <int> <chr>                               <chr>           
#> 1 condensr              199 "Michael Lydeamore [aut, cre] (<ht… 2023-08-30T14:5…
#> 2 HospitalNetwork       229 "Pascal Crépey [aut, cre, cph],\nT… 2023-02-27T07:2…
#> 3 cardinalR             181 "Jayani P.G. Lakshika [aut, cre]\n… 2024-04-16T08:0…
#> 4 quollr                166 "Jayani P.G. Lakshika [aut, cre]\n… 2024-03-05T10:0…
```

## 2. `get_publications`

This function retrieves research publications from Google Scholar and
ORCID, combining the results into a single data frame. It allows for
flexibility in querying either platform based on the availability of
IDs.

``` r
#Example 1: Retrieve publications from both ORCID and Google Scholar
get_publications("0000-0002-2140-5352", "vamErfkAAAAJ")
#> # A tibble: 685 × 5
#>    title                             DOI   authors publication_year journal_name
#>    <chr>                             <chr> <chr>   <lgl>            <chr>       
#>  1 Forecasting: principles and prac… <NA>  RJ Hyn… NA               "OTexts"    
#>  2 Forecasting methods and applicat… <NA>  S Makr… NA               "John Wiley…
#>  3 Another look at measures of fore… <NA>  RJ Hyn… NA               "Internatio…
#>  4 Automatic time series forecastin… <NA>  RJ Hyn… NA               "Journal of…
#>  5 Forecasting with exponential smo… <NA>  RJ Hyn… NA               "Springer V…
#>  6 Detecting trend and seasonal cha… <NA>  J Verb… NA               "Remote sen…
#>  7 forecast: Forecasting functions … <NA>  RJ Hyn… NA               ""          
#>  8 25 years of time series forecast… <NA>  JG De … NA               "Internatio…
#>  9 Sample quantiles in statistical … <NA>  RJ Hyn… NA               "The Americ…
#> 10 A state space framework for auto… <NA>  RJ Hyn… NA               "Internatio…
#> # ℹ 675 more rows
```

``` r
#Example 2: Retrieve publications only from Google Scholar
get_publications(NA, "vamErfkAAAAJ")
#> # A tibble: 353 × 5
#>    title                             DOI   authors publication_year journal_name
#>    <chr>                             <lgl> <chr>   <lgl>            <chr>       
#>  1 Forecasting: principles and prac… NA    RJ Hyn… NA               "OTexts"    
#>  2 Forecasting methods and applicat… NA    S Makr… NA               "John Wiley…
#>  3 Another look at measures of fore… NA    RJ Hyn… NA               "Internatio…
#>  4 Automatic time series forecastin… NA    RJ Hyn… NA               "Journal of…
#>  5 Forecasting with exponential smo… NA    RJ Hyn… NA               "Springer V…
#>  6 Detecting trend and seasonal cha… NA    J Verb… NA               "Remote sen…
#>  7 forecast: Forecasting functions … NA    RJ Hyn… NA               ""          
#>  8 25 years of time series forecast… NA    JG De … NA               "Internatio…
#>  9 Sample quantiles in statistical … NA    RJ Hyn… NA               "The Americ…
#> 10 A state space framework for auto… NA    RJ Hyn… NA               "Internatio…
#> # ℹ 343 more rows
```

``` r
#Example 3: Retrieve publications only from ORCID
get_publications("0000-0002-2140-5352", NA)
#> # A tibble: 332 × 5
#>    title                             DOI   authors publication_year journal_name
#>    <chr>                             <chr> <chr>   <lgl>            <chr>       
#>  1 Cross-temporal probabilistic for… 10.1… <NA>    NA               Internation…
#>  2 Forecast reconciliation: A review 10.1… <NA>    NA               Internation…
#>  3 Forecasting system's accuracy: A… 10.1… <NA>    NA               Applied Sto…
#>  4 Hierarchical Time Series Forecas… 10.1… <NA>    NA               Journal of …
#>  5 Obituary: Everette S Gardner Jr   10.1… <NA>    NA               Internation…
#>  6 Probabilistic forecast reconcili… 10.1… <NA>    NA               European Jo…
#>  7 Probabilistic forecast reconcili… 10.1… <NA>    NA               European Jo…
#>  8 Conditional normalization in tim… <NA>  <NA>    NA               ArXiv       
#>  9 Cross-temporal Probabilistic For… <NA>  <NA>    NA               ArXiv       
#> 10 Forecast combinations: An over 5… 10.1… <NA>    NA               Internation…
#> # ℹ 322 more rows
```

## 3. `get_all_publications`

This function takes a data frame of authors, each with an ORCID ID and a
Google Scholar ID, and returns their combined publications.

``` r
authors_df <- tibble::tibble(
orcid_id = c("0000-0002-2140-5352", "0000-0002-1825-0097", NA, "0000-0001-5109-3700"),
scholar_id = c(NA, "vamErfkAAAAJ", "4bahYMkAAAAJ", NA)
)
get_all_publications(authors_df)
#> # A tibble: 1,111 × 5
#>    title                             DOI   authors publication_year journal_name
#>    <chr>                             <chr> <chr>   <lgl>            <chr>       
#>  1 Cross-temporal probabilistic for… 10.1… <NA>    NA               Internation…
#>  2 Forecast reconciliation: A review 10.1… <NA>    NA               Internation…
#>  3 Forecasting system's accuracy: A… 10.1… <NA>    NA               Applied Sto…
#>  4 Hierarchical Time Series Forecas… 10.1… <NA>    NA               Journal of …
#>  5 Obituary: Everette S Gardner Jr   10.1… <NA>    NA               Internation…
#>  6 Probabilistic forecast reconcili… 10.1… <NA>    NA               European Jo…
#>  7 Probabilistic forecast reconcili… 10.1… <NA>    NA               European Jo…
#>  8 Conditional normalization in tim… <NA>  <NA>    NA               ArXiv       
#>  9 Cross-temporal Probabilistic For… <NA>  <NA>    NA               ArXiv       
#> 10 Forecast combinations: An over 5… 10.1… <NA>    NA               Internation…
#> # ℹ 1,101 more rows
```

## 4. `cran_all_pubs

This function retrieves CRAN package download statistics for multiple
authors by their first and last names.

``` r
cran_authors <- tibble::tibble(
  first_name = c("Michael", "Rob"),
  last_name = c("Lydeamore", "Hyndman")
)

cran_all_pubs(cran_authors)
#> # A tibble: 42 × 4
#>    name            downloads authors                            last_update_date
#>    <chr>               <int> <chr>                              <chr>           
#>  1 condensr              199 "Michael Lydeamore [aut, cre] (<h… 2023-08-30T14:5…
#>  2 HospitalNetwork       229 "Pascal Crépey [aut, cre, cph],\n… 2023-02-27T07:2…
#>  3 cardinalR             181 "Jayani P.G. Lakshika [aut, cre]\… 2024-04-16T08:0…
#>  4 quollr                166 "Jayani P.G. Lakshika [aut, cre]\… 2024-03-05T10:0…
#>  5 forecast           207836 "Rob Hyndman [aut, cre, cph] (<ht… 2024-06-20T02:1…
#>  6 rmarkdown         1023668 "JJ Allaire [aut],\nYihui Xie [au… 2024-08-17T03:5…
#>  7 hdrcde               9320 "Rob Hyndman [aut, cre, cph] (<ht… 2021-01-18T05:2…
#>  8 demography           1538 "Rob Hyndman [aut, cre, cph] (<ht… 2023-02-08T07:2…
#>  9 tsfeatures          20102 "Rob Hyndman [aut, cre] (<https:/… 2023-08-28T13:0…
#> 10 tsibble             29973 "Earo Wang [aut, cre] (<https://o… 2024-06-27T12:2…
#> # ℹ 32 more rows
```

## Dataset

`orcid_gsid.csv`

This dataset contains mappings between researchers’ names and their
respective ORCID and Google Scholar IDs. It is useful for linking and
identifying academic profiles across different platforms.

``` r
print(orcid_gsid)
#> # A tibble: 56 × 4
#>    first_name last_name orcid_id            gsuser_id   
#>    <chr>      <chr>     <chr>               <chr>       
#>  1 Akanksha   Negi      0000-0003-2531-9408 Gcz8Ng0AAAAJ
#>  2 Alan       Powell    <NA>                <NA>        
#>  3 Andrew     Matthews  <NA>                <NA>        
#>  4 Ann        Maharaj   0000-0002-5513-962X BZ07eocAAAAJ
#>  5 Athanasios Pantelous 0000-0001-5738-1471 ZMaiiQwAAAAJ
#>  6 Benjamin   Wong      0000-0002-1665-6165 Nneg6GAAAAAJ
#>  7 Bin        Peng      0000-0003-4231-4713 5d3ZOm4AAAAJ
#>  8 Bonsoo     Koo       0000-0002-7247-9773 OmK08lAAAAAJ
#>  9 Brett      Inder     <NA>                Wx6eeWgAAAAJ
#> 10 Catherine  Forbes    0000-0003-3830-5865 jm73LccAAAAJ
#> # ℹ 46 more rows
```

## Dependencies

This package relies on the following R packages:

- pkgsearch
- tibble
- dplyr
- stringr
- scholar
- rorcid

You can install these dependencies using install.packages()

``` r
install.packages(c("pkgsearch", "tibble", "dplyr", "stringr", "scholar", "rorcid"))
```

## License
MIT License

