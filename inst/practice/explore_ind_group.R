library(rvest)


url_narrow <- "https://usfencingresults.org/rankings/"
site_narrow <- read_html(url_narrow)
site_li <- site_narrow |> html_elements("li")

dir_df <- data.frame(
  label = site_li[-1] |> html_attr("data-name"),
  link = paste0(
    url_narrow, 
    site_li[-1] |> html_attr("data-href")
  )
)

url_i <- dir_df$link[5]
site_i <- read_html(url_i)
site_li_i <- site_i |> html_elements("li")

ind_df <- data.frame(
  label = site_li_i[-1:-2] |> html_attr("data-name"),
  link = paste0(
    url_narrow, 
    site_li_i[-1:-2] |> html_attr("data-href")
  )
)
