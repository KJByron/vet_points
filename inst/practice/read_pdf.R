
# x_doc <- "WE V50 R 2025 07 10.pdf"
x_page <- "https://usfencingresults.org/rankings/Women%27s%20Epee/WE%20V50%20R%202025%2007%2010.pdf"
# points <- read_html(x_page)
pdf_raw <- pdftools::pdf_text(pdf = x_page)

# left pages have 'RANK' as initial column name, right do not
# merge left and right by 'NAME'
raw1 <- strsplit(pdf_raw[1], "\n")[[1]]
raw2 <- strsplit(pdf_raw[2], "\n")[[1]]

# pdf_row <- 