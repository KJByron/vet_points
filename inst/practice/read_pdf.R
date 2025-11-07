## general output non-homogenous, restrict to vets
# x_page <- "https://usfencingresults.org/rankings/Women%27s%20Epee/WE%20Sr%20R%202025%2010%2006.pdf"

# x_doc <- "WE V50 R 2025 07 10.pdf"
x_page <- "https://usfencingresults.org/rankings/Women%27s%20Epee/WE%20V50%20R%202025%2007%2010.pdf"
# use men to get multiple pages
x_page <- "https://usfencingresults.org/rankings/Men%27s%20Epee%20/ME%20V50%20R%202025%2007%2010.pdf"
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
        x_page <- x_page[length(x_page) != 0]

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
row_median <- sapply(row_length_list, median)

body_list <- purrr::map(
  seq_along(row_median),
  function(i_row) {
    # i_row <- 1
    n_col <- row_median[i_row]
    x <- row_list[[i_row]]
    x <- x[sapply(x, length) == n_col]
    out <- matrix(unlist(x), nrow = length(x), ncol = n_col, byrow = !FALSE)
    out_head <- out[1, , drop = TRUE]
    out <- out[-1, , drop = FALSE]
    out <- as.data.frame(out)
    names(out) <- out_head
    out
  }
)

body_df_list <- purrr::map(
  split(body_list, sapply(body_list, ncol)),
  dplyr::bind_rows
)

