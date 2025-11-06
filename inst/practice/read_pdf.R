
# x_doc <- "WE V50 R 2025 07 10.pdf"
x_page <- "https://usfencingresults.org/rankings/Women%27s%20Epee/WE%20V50%20R%202025%2007%2010.pdf"
x_page <- "https://usfencingresults.org/rankings/Women%27s%20Epee/WE%20Sr%20R%202025%2010%2006.pdf"
pdf_raw <- pdftools::pdf_text(pdf = x_page)

# left pages have 'RANK' as initial column name, right do not
# merge left and right by 'NAME'
row_list <- purrr::map(
  seq_along(pdf_raw),
  function(i_page) {
    # i_page <- 1
    x_page <- strsplit(pdf_raw[i_page], "\n")[[1]]
    x_list <- purrr::map(
      seq_along(x_page),
      function(i_row) {
        # i_row <- 12; i_row <- 28
        
        # drop blanks
        x_list <- x_list[lengths(x_list) != 0]

        ## split spaces
        # multiple spaces between characters
        # may be only 1 space between numbers
        x_row <- strsplit(x_page[i_row], " {2, }")[[1]]
        x_row <- x_row[x_row != ""]
        
        x_row <- sapply(x_row, function(x) {
          is_num <- suppressWarnings(!is.na(readr::parse_number(x)))
          if (!is_num) {
            out <- x
          } else {
            out <- strsplit(x, " ")[[1]]
          }
          names(out) <- NULL
          out
        }) |> c(recursive = TRUE)
        
        x_row
      }
    )
    x_list
  }
)
row_length_list <- purrr::map(
  row_list, 
  function(x_row) {
    sapply(x_row, length)
  }
) 
sapply(row_length_list, median)

# pdf_row <- 