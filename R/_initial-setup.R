#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)

main_title <- args[1] # "MAIN TITLE"
main_description <- paste("Analysis and results for", 
                          tolower(main_title), 
                          "project.") # "MAIN DESCRIPTION"
bs <- gsub(" ", "-", main_title)
book_filename <- tolower(bs) # "book-filename"
book_directory <- file.path("Books", bs) # "Books/Book-Name"
git_repo <- args[2] # "https://github.com/FredHutch/"
author_name <- args[3] # "icj [icj @ email]"

# Directories -------------------------------------------------------------

dirs_to_make <- c(
  "Data",
  "Output",
  "Output/Data",
  "Output/Figures",
  "Output/Tables",
  "Info",
  "Books",
  "tmp"
)

# Files -------------------------------------------------------------------

files_to_make <- c(
  readme_md = "README.md",
  gitignore = ".gitignore",
  index_rmd = "index.Rmd",
  bookdown_yml = "_bookdown.yml",
  output_yml = "_output.yml",
  style_css = "style.css"
)

# README.md ---------------------------------------------------------------

readme_md <- c(
  paste('#', main_title),
  '',
  paste("- Created:", format(Sys.time())),
  paste("- Results:", book_directory),
  paste("- Git Repo:", git_repo),
  '',
  "## Description",
  '',
  main_description
)

# .gitignore --------------------------------------------------------------

gitignore <- c(
  '.Rproj.user',
  '.Rhistory',
  '.RData',
  '.Ruserdata',
  '.DS_Store',
  'Data/', 
  'Data',
  'Output/',
  'Thumbs.db',
  'slurm*',
  '~$*',
  'Info/',
  'Book*',
  '_bookdown_files',
  '*.rds',
  'tmp/'  
)

# index.Rmd ---------------------------------------------------------------

index_rmd <- c(
  '---',
  paste0('title: "', main_title, '"'),
  'author:', 
  paste0('  - "', author_name, '"'),
  'date: "Last run: `r format(Sys.time())`"',
  'site: bookdown::bookdown_site',
  'documentclass: book',
  'link-citations: yes',
  paste0('description: "', main_description, '"'),
  '---',
  '',
  '# Overview',
  '',
  '- Item 1',
  '- Item 2',
  '',
  '## Change log',
  '',
  '```{r, tab-0-1, echo = FALSE}',
  'library(magrittr)',
  'repo <- git2r::repository(".")',
  'lapply(git2r::commits(repo), as.data.frame) %>%', 
  '  dplyr::bind_rows(.) %>%', 
  '  dplyr::select(when, commit = sha, message = summary, author) %>%', 
  '  dplyr::mutate(commit = substr(commit, 1, 7)) %>%', 
  '  dplyr::slice(1:10) %>%', 
  '  knitr::kable(booktabs = TRUE,', 
  '               caption = "Last 10 commits to the git repository.")',
  '```'
)

# _bookdown.yml -----------------------------------------------------------

bookdown_yml <- c(
  paste0('book_filename: "', book_filename, '"'),
  'delete_merged_file: true',
  'language:',
  '  ui:',
  '  chapter_name: ""',
  'new_session: yes',
  paste0('output_dir: "', book_directory, '"'),
  'before_chapter_script: ["R/00-book-tools.R", "R/00-analysis-tools.R"]'
)

# _output_yml -------------------------------------------------------------

output_yml <- c(
  'bookdown::gitbook:',
  '  css: style.css',
  '  config:',
  '    toc:',
  '      collapse: section',
  '      before: |',
  paste0('        <li><a href="./">', main_title, '</a></li>'),
  '      after: |',
  paste0('        <li><a>', author_name, '</a></li>'),
  paste0('        <li><a href="', git_repo, '" target="blank">GitHub Repo</a></li>'),
  '    download: no',
  '    sharing:',
  '      facebook: no',
  '      twitter: no',
  '      all: no',
  'bookdown::pdf_book:',
  '  includes:',
  '    in_header: preamble.tex',
  '  latex_engine: xelatex',
  '  citation_package: natbib',
  '  keep_tex: yes'
)

# style.css ---------------------------------------------------------------

style_css <- c(
  'p.caption {',
  '  color: #777;',
  '    margin-top: 10px;',
  '}',
  'p code {',
  '  white-space: inherit;',
  '}',
  'pre {',
  '  word-break: normal;',
  '  word-wrap: normal;',
  '}',
  'pre code {',
  '  white-space: inherit;',
  '}',
  'caption {',
  '  text-align:left;',
  '}'
)

# Create directories ------------------------------------------------------

invisible(lapply(dirs_to_make, dir.create))

# Create files ------------------------------------------------------------

invisible(lapply(names(files_to_make), function(x) {
  writeLines(eval(parse(text = x)), files_to_make[x])
}))
