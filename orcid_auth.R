library(httr)
orcid_client_id <- "APP-B9MWICVT9H801B95"

orcid_client_secret <- "7b5812cd-30d8-48c9-a2b7-4c739520ced1"

orcid_request <- POST(url  = "https://orcid.org/oauth/token",
                      config = add_headers(`Accept` = "application/json",
                                           `Content-Type` = "application/x-www-form-urlencoded"),
                      body = list(grant_type = "client_credentials",
                                  scope = "/read-public",
                                  client_id = orcid_client_id,
                                  client_secret = orcid_client_secret),
                      encode = "form")

orcid_response <- content(orcid_request)
print(orcid_response$access_token)

Sys.setenv("ORCID_TOKEN"=orcid_response$access_token)
