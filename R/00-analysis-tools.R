################################################################################
# Analysis tools
# To be run before other R/##.R scripts
################################################################################

# Define project variables ------------------------------------------------

source("R/00-study-parameters.R")


# Helper functions --------------------------------------------------------

sniff <- function (x, ...) {
  UseMethod("sniff", x)
}

sniff.default <- function(x, ...) {
  library(tidyverse)
  m_call <- x$call %>% as.character
  tibble(method = m_call[1],
         formula = formula.tools:::as.character.formula(formula(x)),
         n = length(residuals(x)),
         result = list(tidy(x, conf.int = TRUE, ...))) %>% 
    unnest
}

tbl_strata <- function(df, strata, name_all = "All", sep = "___") {
  # strata should be a list of vectors to stratify df by;
  # each vector should have length = nrow(df)
  # if named list, then the names become 
  # columns in the data frame (duplicate names are ajusted)
  # if not a named list, then generic names are made
  
  stopifnot(is.list(strata))
  stopifnot(all(sapply(strata, is.atomic)))
  
  chk <- lapply(strata, length)
  stopifnot(all(chk == nrow(df)))
  
  strata <- lapply(strata, as.factor)
  
  nn <- if (is.null(names(strata))) {
    paste0("s_", seq_along(strata))
  } else {
    names(strata)
  }
  nn[nn == ""] <- "no_name"
  nn <- tail(make.unique(c(names(df), nn), sep = "__"), length(nn))
  names(strata) <- nn
  
  cc <- split(df, strata, sep = "___")
  dd <- bind_rows(cc, .id = "sss") %>% 
    separate(sss, names(strata), sep = sep) %>% 
    bind_rows(df)
  
  for (x in names(strata)) {
    dd[[x]] <- factor(dd[[x]], levels = levels(strata[[x]]))
    dd[[x]] <- fct_explicit_na(dd[[x]], name_all)
  }
  
  dd
}

gsub_leq <- function(x) gsub("<=", "\u2264", x)
