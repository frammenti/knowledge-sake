library(tidyverse)
library(rjstat)
library(jsonlite)
library(countrycode)

options(readr.show_col_types = FALSE)

titles <- c('mean_scores', 'mean_scores_escs', 'mean_scores_hisced', 'mean_scores_books', 
           'mean_scores_artworks', 'mean_scores_classics', 'mean_scores_lonely', 'mean_scores_computer', 
           'corr_scores', 'freq_scores', 'freq_escs', 'freq_hisced', 'freq_scores_escs', 
           'freq_scores_hisced', 'freq_books')

desc <- list('Math and Reading Proficiency', 'Math and Reading Proficiency by Socio-Economic Status',
                  "Math and Reading Proficiency by Parents' Education", 'Math and Reading Proficiency by Book Possession',
                  'Math and Reading Proficiency by Artwork Possession', "Math and Reading Proficiency by Classics' Possession",
                  'Math and Reading Proficiency by Loneliness', 'Math and Reading Proficiency by Frequency of Computer Use',
                  'Math, Reading and Socio-Economic Status Correlation', 'Distribution of Math and Reading Levels',
                  'Distribution of Socio-Economic Quartiles', "Distribution of Parents' Education Level",
                  'Distribution of Math and Reading Levels over Socio-Economic Quartiles', "Distribution of Math and Reading Levels over Parents' Education",
                  'Distribution of Book Possession')

years <- c('2000', '2003', '2006', '2009', '2012', '2015', '2018', '2022')

countries <- c('AUT', 'BEL', 'BGR', 'HRV', 'CZE', 'DNK', 'EST', 'FIN', 'FRA', 'DEU',
               'GRC', 'HUN', 'IRL', 'ITA', 'LVA', 'LTU', 'LUX', 'MLT', 'NLD', 'POL',
               'PRT', 'ROU', 'SVK', 'SVN', 'ESP', 'SWE', 'GBR', 'EU28')

year_df <- tibble(
  column = 'year',
  uri = years,
  key = years,
  label = ''
)

area_df <- tibble(
  column = 'area',
  uri = countries,
  key = countries,
  label = suppressWarnings(countrycode(countries, origin = 'iso3c', destination = 'country.name'))
) |> mutate(
  label = case_when(
    key == 'EU28' ~ 'European Union (28 countries)',
    .default = label
    
  )
)

map_df <- read.csv('PISA_mapping.csv', stringsAsFactors = FALSE)
map_df <- bind_rows(year_df, area_df, map_df) |>
  mutate(key = sprintf('%03d_%s', seq_along(key), key))

maps <-  split(map_df, map_df$column) |>
  lapply(\(df) split(df, df$uri))

res <- list()
full_titles <- c()

for (i in seq_along(titles)) {
  title <- titles[i]
  full_title <- paste0('D1.', i, '_PISA_', title)
  df <- read_csv(paste0('../datasets/source/csv/D1/', full_title, '.csv'))
  full_titles <- append(full_titles, full_title)
  
  df <- df |> 
    mutate(across(1:(ncol(df) - 1), ~ map_df$key[match(.x, map_df$uri)]))
  
  res[[title]] <- df
}

# Strip zero-padding
map_df$key <- gsub('^\\d+_', '', map_df$key)


jraw <- toJSONstat(res, pretty = TRUE, digits = NA)  
j <- fromJSON(jraw, simplifyVector = FALSE)

j$href <- 'https://w3id.org/knowledge-sake/D1_secondary_education.json'
j$label <- "Datasets on 15-year-old Student Performance and Socio-Economic Background in the EU 2000-2022"
j$note <- c('The datasets use rescaled indices of economic, social, and cultural status (ESCS) for trend analysis provided by the OECD: those of the years 2000, 2003, 2006, and 2009 have been harmonized to 2015, those of 2012, 2015 and 2018 to 2022.')
j$source <- 'Organization for Economic Cooperation and Development (OECD), Program for International Student Assessment (PISA), 2000, 2003, 2006, 2009, 2012, 2015, 2018, and 2022 Reading and Mathematics Assessments.'
j$updated <- format(Sys.Date(), '%Y-%m-%d')
j$link$alternate <- list(
  list(
    type = 'text/turtle',
    href = 'https://w3id.org/knowledge-sake/D1_secondary_education.ttl'
  )
)
j$extension$metadata <- list(
  list(
    title = 'Dataset Visualization and Analysis',
    href = 'https://w3id.org/knowledge-sake/datasets/secondary-education'
  ),
  list(
    title = 'Dataset Metadata',
    href = 'https://w3id.org/knowledge-sake/metadata#secondary-education'
  ),
  list(
    title = 'Project Documentation',
    href = 'https://w3id.org/knowledge-sake/documentation'
  ),
  list(
    title = 'PISA Data and Methodology',
    href = 'https://www.oecd.org/en/about/programmes/pisa/pisa-data.html'
  ),
  list(
    title = 'PISA Data Files',
    href = 'https://webfs.oecd.org/pisa2022/index.html'
  ),
  list(
    title = 'OECD Glossary of Statistical Terms',
    href = 'https://doi.org/10.1787/9789264055087-en'
  )
)

j <- j[c('version', 'class', 'href', 'label', 'note', 'source', 'updated', 'extension', 'link')]
j$link <- j$link[c('alternate', 'item')]

# Map index values to their corresponding labels
add_labels <- function(idx, df) {
  labels <- map(idx, ~ df$label[match(.x, df$key)])
  set_names(labels, idx)
}

title_desc <- map2(full_titles, desc, ~ list(title = .x, desc = .y))

j$link$item <- imap(j$link$item, function(d, y) {
  i <- title_desc[[y]]
  
  d$label <- i$desc
  d$link$alternate <- list(
    list(
      type = 'text/csv',
      href = paste0('https://w3id.org/knowledge-sake/', i$title, '.csv')
    )
  )
  
  d$role <- list(
    time = list('year'),
    geo = list('area'),
    metric = list('metric')
  )
  
  d$updated <- format(Sys.Date(), '%Y-%m-%d')
  
  d$dimension <- imap(d$dimension, function(dim, name) {
    dim$label <- map_df$label[match(name, map_df$uri)]
    dim$category$index <- sub('^\\d+_', '', dim$category$index)  # Strip zero-padding
    dim$category$label <- add_labels(dim$category$index, map_df)  # Labels with named keys
    dim <- dim[c('label', 'category')]
    dim
  })
  
  d$dimension$concept$label <- 'Indicator'
  
  d$dimension$year$label <- 'Year'
  d$dimension$year$category <- d$dimension$year$category[c('index')]
  
  d$dimension$area$label <- 'Country'
  cnt <- d$dimension$area$category$index
  d$dimension$area$category$child <- set_names(list(setdiff(cnt, "EU28")), "EU28")
  
  d$dimension$metric$label <- 'Measure'
  metrics <- d$dimension$metric$category$index
  
  d$dimension$metric$category$unit <- set_names(
    map(metrics, ~ list(
      symbol = map_df$symbol[match(.x, map_df$key)],
      decimals = map_df$decimals[match(.x, map_df$key)]
    )),
    metrics
  )
  
  d <- d[c('class', 'label', 'updated', 'link', 'value', 'id', 'size', 'role', 'dimension')]
  
  d
})
  

jfinal <- toJSON(j, pretty = TRUE, digits = NA, auto_unbox = TRUE, na = 'null', null = 'null')  
write(jfinal, '../datasets/source/json/D1_secondary_education.json')



