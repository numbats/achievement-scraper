#All articles per year, including their links
#Summarised articles by author, journals, and rankings
#For each staff member: h-index, total citations, top 10 cited outputs
#Package name, number of downloads, date of last update

We can aim to have two dataframes:
One for research outputs and one for software.

1. #display authors' GSID
id <- "Gcz8Ng0AAAAJ"

2. #Display the authors who had collaboration with this author
authorlist <- scholar::get_publications(id)$author

3. #this will display the profile of the said author
author <- scholar::get_profile(id)$name


4. #This will extract the number of authors as well as their
   #exact position in the article for each article in the GS profile

author_position(authorlist, author)

5. #This will extracct all the article of the profile with all information

format_publications("Gcz8Ng0AAAAJ")

6. #This will create a co-author network data frame

coauthor_network <- get_coauthors("Gcz8Ng0AAAAJ")

7. #This will create an ID data frame of the researcher

idp <- get_publications("Gcz8Ng0AAAAJ")

8. # This creates an impact data frame of the Journals in which the
   # researcher has had published their articles

impact <- get_journalrank(journals=idp$journal)

idp <- cbind(idp,impact)

9. #This will give exact number of the article available
   #in the GS profile

get_num_articles("Gcz8Ng0AAAAJ")

10. #This will give the number of distinct Source titles/Journals
    #in which the researcher has had published these articles

get_num_distinct_journals("Gcz8Ng0AAAAJ")


11. #This will extract the details like Volume, Issue, Page Number,
    #number of citations and publications year of each article and also
    #the publication ID of each article in the profile

get_publications("Gcz8Ng0AAAAJ",
                 cstart = 0,
                 cstop = Inf,
                 pagesize = 100,
                 flush = FALSE,
                 sortby = "citation"
)

