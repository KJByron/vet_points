library(rvest)

## start from main point standing page
url <- "https://www.usafencing.org/point-standings"
site_main <- rvest::read_html(url)


site_narrow <- rvest::read_html("https://usfencingresults.org/rankings/")
# not sure where url came from for site_narrow
# or how to navigate from site_main to needed part
site_main |> html_elements("main") |> html_elements("li") |> html_elements("a")
(site_main |> html_elements("main") |> html_elements("li") |> html_elements("a"))[6]

if (FALSE) {  # see structure overview, no values
  xml2::html_structure(site_main)
  xml2::html_structure(site_narrow) 
}

site_main |> html_elements("li")
site_narrow  |> html_elements("li")
# {xml_nodeset (8)}
# [1] <li>\n                            <a href="javascript:void(0)" id="page-top-lin ...
# [2] <li data-name="Men's Epee " data-href="?dir=Men%27s%20Epee%20">\n               ...
# [3] <li data-name="Men's Foil" data-href="?dir=Men%27s%20Foil">\n                   ...
# [4] <li data-name="Men's Saber" data-href="?dir=Men%27s%20Saber">\n                 ...
# [5] <li data-name="Parafencing" data-href="?dir=Parafencing">\n                     ...
# [6] <li data-name="Women's Epee" data-href="?dir=Women%27s%20Epee">\n               ...
# [7] <li data-name="Women's Foil" data-href="?dir=Women%27s%20Foil">\n               ...
# [8] <li data-name="Women's Saber" data-href="?dir=Women%27s%20Saber">\n             ...
site_li <- site_narrow |> html_elements("li")


xml2::html_structure(site_li[[6]])  # see structure overview, no values

html_text2(site_li[[6]])
# [1] "Women's Epee - 2025-10-20 13:39:18"

html_children(site_li[[6]])
# {xml_nodeset (1)}
# [1] <a href="?dir=Women%27s%20Epee" class="clearfix" data-name="Women's Epee">\n\n\ ...

html_elements(site_li[[6]], "span")
# [1] <span class="file-name col-md-7 col-sm-6 col-xs-9">\n                           ...
# [2] <span class="file-size col-md-2 col-sm-2 col-xs-3 text-right">\n                ...
# [3] <span class="file-modified col-md-3 col-sm-4 hidden-xs text-right">\n           ...

site_li[[6]] |> html_attrs()
#        data-name               data-href 
#   "Women's Epee" "?dir=Women%27s%20Epee" 

site_li[[6]] |> html_attr("data-name")
# [1] "Women's Epee"
site_li[[6]] |> html_attr("data-href")
# [1] "?dir=Women%27s%20Epee"

site_li[-1] |> html_attr("data-name")
site_li[-1] |> html_attr("data-href")

# get full page name
#   "?dir=Women%27s%20Epee" to
#   "https://usfencingresults.org/rankings/?dir=Women%27s%20Epee"