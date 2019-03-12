################################################################################
# Tools for book construction
################################################################################

loop_fig <- function(fig_name, lab, cap, args = NULL, gnp = FALSE) {
  stopifnot(length(lab) == length(cap))
  args <- if (!is.null(args)) {
    paste(",", paste(args, collapse = ", "))
  } else args
  for (i in seq_along(cap)) {
    cat(paste0("\n```{r, ", lab[i], ", fig.cap = '", cap[i], "', ",
               "echo = FALSE", args, "}\n"))
    cat(paste0("print(", fig_name, "[[", i, "]])\n"))
    if (gnp) {
      cat("grid::grid.newpage()\n")
    }
    cat("```\n")
  }
}

collapse_vec <- function(x) {
  if (length(x) <= 1) return(x)
  
  out <- if (length(x) == 2) {
    paste(x, collapse = " and ")
  } else if (length(x) >= 2) {
    paste0(paste(x[-length(x)], collapse = ", "), 
           ", and ", tail(x, 1))
  } else NULL
  
  out
}

preview_tbl <- function(x, cols = 5, rows = 10) {
  nr <- min(nrow(x), rows)
  nc <- min(ncol(x), cols)
  knitr::kable(
    x[1:nr, 1:nc],
    booktabs = TRUE,
    caption = paste0("The first ", nc, " columns and ", nr, " rows of ",
                     "`", deparse(substitute(x)), "`.")
  )
}

df_arsenal <- function(x, labs = NULL, ...) {
  a1 <- x %>% 
    summary(text = TRUE) %>% 
    as.data.frame %>% 
    select(variable = 1) %>% 
    mutate(variable = if_else(grepl("^-  ", variable), NA_character_,
                              variable)) %>% 
    fill(variable)
  
  a2 <- x %>% 
    summary(text = TRUE, labelTranslations = labs, ...) %>% 
    as.data.frame
  
  bind_cols(a1["variable"], a2) %>% 
    rename(` ` = V1)
}

make_dl_link <- function(x, path){
  type <- tools::file_ext(path)
 
  if (type == "csv") {
    readr::write_csv(x, path)
  } else if (type == "xlsx") {
    writexl::write_xlsx(x, path)
  } 
  
  htmltools::a(paste("Download", basename(path)), 
               href = path, 
               download = basename(path))
}
