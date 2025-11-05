## following https://www.r-bloggers.com/2025/10/pledging-my-time-vii/
# devtools::load_all()

# library(rvest)
# library(dplyr)
# library(purrr)
# library(stringr)
# library(ggforce)


## Functions ----
# retrieves the data frame from the main function
scrape_results_page <- function(url) {
  webpage <- rvest::read_html(url)
  df <- scrape_startlist(webpage)
  df <- df[-1, ]
  return(df)
}

# scrapes the data
scrape_startlist <- function(page) {
  rows <- page |> rvest::html_nodes("li.list-group-item.row")
  purrr::map_df(rows, function(row) {
    # helper to get text from a selector, remove small labels and trim
    get_text <- function(sel) {
      node <- row |> rvest::html_node(sel)
      if (is.na(node) || length(node) == 0) return(NA_character_)
      # remove the mobile label nodes inside if present
      node |> rvest::html_nodes(".visible-xs-block, .visible-sm-block, .list-label") |> xml2::xml_remove()
      text <- node |> html_text(trim = TRUE)
      if (length(text) == 0) return(NA_character_) else return(text)
    }
    
    # place primary/secondary
    place_primary <- get_text(".type-place.place-primary")
    place_secondary <- get_text(".type-place.place-secondary")
    
    # fullname and link
    fullname_a <- row |> rvest::html_node("h4.type-fullname a")
    fullname <- if (length(fullname_a) == 0) NA_character_ else fullname_a |> html_text(trim = TRUE)
    link <- if (length(fullname_a) == 0) NA_character_ else fullname_a |> html_attr("href")
    
    # bib, club/city, age class (these are under second column)
    bib <- get_text(".type-field")
    club_city <- get_text(".type-priority")
    age_class <- get_text(".type-age_class")
    
    # finish and gun time: there are multiple .type-time entries; take them in order
    times <- row |> rvest::html_nodes(".type-time") |> html_text(trim = TRUE)
    times <- times[times != ""] # drop blanks
    finish <- if (length(times) >= 1) times[1] else NA_character_
    gun_time <- if (length(times) >= 2) times[2] else NA_character_
    
    # make data frame. We don't need gun time or link
    data.frame(
      place_primary = place_primary,
      place_secondary = place_secondary,
      fullname = fullname,
      bib = bib,
      club_city = club_city,
      age_class = age_class,
      finish = finish
    )
  })
}


if(FALSE) {
  # Specifying the base url for website to be scraped
  url <- "https://live.frankfurt-marathon.com/2025/?page="
  
  # the pages are like this:
  # "https://live.frankfurt-marathon.com/2025/?page=2&event=L_HCH3BKLB3B8&num_results=1000&pid=startlist_list&pidp=startlist&search%5Bage_class%5D=%25&search%5Bsex%5D=%25&search%5Bnation%5D=%25&search_sort=name"
  # we have 1000 results on a page and the first page shows there are 16 pages total
  n_pages <- 16
  # make a list of all urls to be scraped
  urls <- paste0(url, seq(n_pages), "&event=L_HCH3BKLB3B8&num_results=1000&pid=startlist_list&pidp=startlist&search%5Bage_class%5D=%25&search%5Bsex%5D=%25&search%5Bnation%5D=%25&search_sort=name")
  # scrape each page one by one and rbind into large df
  result  <- do.call(rbind, lapply(urls, scrape_results_page))
}