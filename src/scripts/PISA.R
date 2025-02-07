# The older files must be downloaded manually from:
# https://webfs.oecd.org/pisa2022/index.html

# Then the .sps control file must be applied to the .txt student dataset to obtain the .sav
# using any open-source spss processor

# From 2015, the .sav files can be downloaded directly with the following commands:
# curl --output 2015.zip "https://webfs.oecd.org/pisa/PUF_SPSS_COMBINED_CMB_STU_QQQ.zip"
# curl --output 2018.zip "https://webfs.oecd.org/pisa2018/SPSS_STU_QQQ.zip"
# curl --output 2022.zip "https://webfs.oecd.org/pisa2022/STU_QQQ_SPSS.zip"

# To run the code, the directory structure must be such as:
# .
# ├── PISA
# │   ├── 2000math.sav
# │   ├── 2000read.sav
# │   ├── 2003.sav
# │   ├── 2006.sav
# │   ├── 2009.sav
# │   ├── 2012.sav
# │   ├── 2015.sav
# │   ├── 2018.sav
# │   ├── 2022.sav
# │   └── ESCS
# │       ├── 2000.sav
# │       ├── 2003.sav
# │       ├── 2006.sav
# │       ├── 2009.sav
# │       └── escs_trend.csv
# ├── PISA.R
# └── PISA_labels.json

library(jsonlite)
library(tidyverse)
library(Rrepest)
library(haven)
library(labelled)

years = c('2000', '2003', '2006', '2009', '2012', '2015', '2018', '2022')

countries <- c('AUT','BEL','BGR','CZE','CYP','DEU','DNK','ESP','EST','FIN',
               'FRA','GBR','GRC','HRV','HUN','IRL','ITA','LTU','LUX','LVA',
               'MLT','NLD','POL','PRT','ROU','SVK','SVN','SWE')

eu <- grp('EU28','area', countries)

escs_csv <- read.csv('PISA/ESCS/escs_trend.csv')

# Reference to harmonize value labels
labels <- list()
label_map <- fromJSON("PISA_labels.json", simplifyVector = FALSE)

# Store results
res_codes <- c('mean_scores', 'mean_scores_escs', 'mean_scores_hisced', 'mean_scores_books', 'mean_scores_artworks', 'mean_scores_classics', 'mean_scores_lonely', 'mean_scores_computer', 'corr_scores', 'freq_scores', 'freq_escs', 'freq_hisced', 'freq_scores_escs', 'freq_scores_hisced', 'freq_books_etc')
res <- setNames(vector("list", length(res_codes)), res_codes)

# Configuration by year
year_config <- list(
  '2000' = list(
    weights = c('w_fstuwt', paste0('w_fstr', 1:80)),
    survey = 'PISA',
    hisei = 'hisei',
    escs = 'escs_trend',
    books = 'st37q01',
    artworks = 'st21q11',
    classics = 'st21q09',
    lonely = 'st31q06',
    computer = 'st39q02',
    escs_sav = TRUE,
    cycle = 1
  ),
  '2003' = list(
    weights = c('w_fstuwt', paste0('w_fstr', 1:80)),
    survey = 'PISA',
    hisei = 'hisei',
    escs = 'escs_trend',
    books = 'st19q01',
    artworks = 'st17q10',
    classics = 'st17q08',
    lonely = 'st27q06',
    computer = 'ic04q01',
    escs_sav = TRUE,
    cycle = 2
  ),
  '2006' = list(
    weights = c('w_fstuwt', paste0('w_fstr', 1:80)),
    survey = 'PISA',
    hisei = 'hisei',
    escs = 'escs_trend',
    books = 'st15q01',
    artworks = 'st13q10',
    classics = 'st13q08',
    computer = 'ic03q01',
    escs_sav = TRUE,
    cycle = 3
  ),
  '2009' = list(
    weights = c('w_fstuwt', paste0('w_fstr', 1:80)),
    survey = 'PISA',
    hisei = 'hisei',
    escs = 'escs_trend',
    books = 'st22q01',
    artworks = 'st20q09',
    classics = 'st20q07',
    computer = 'ic04q06',
    escs_sav = TRUE,
    cycle = 4
  ),
  '2012' = list(
    weights = c('w_fstuwt', paste0('w_fstr', 1:80)),
    survey = 'PISA',
    hisei = 'hisei_trend',
    escs = 'escs_trend',
    books = 'st28q01',
    artworks = 'st26q09',
    classics = 'st26q07',
    lonely = 'st87q06',
    escs_csv = TRUE,
    cycle = 5
  ),
  '2015' = list(
    weights = NULL,
    survey = 'PISA2015',
    hisei = 'hisei_trend',
    escs = 'escs_trend',
    books = 'st013q01ta',
    artworks = 'st011q09ta',
    classics = 'st011q07ta',
    lonely = 'st034q06ta',
    escs_csv = TRUE,
    cycle = 6
  ),
  '2018' = list(
    weights = NULL,
    survey = 'PISA2015',
    hisei = 'hisei_trend',
    escs = 'escs_trend',
    books = 'st013q01ta',
    artworks = 'st011q09ta',
    classics = 'st011q07ta',
    lonely = 'st034q06ta',
    escs_csv = TRUE,
    cycle = 7
  ),
  '2022' = list(
    weights = NULL,
    survey = 'PISA2015',
    hisei = 'hisei',
    escs = 'escs',
    books = 'st255q01ja',
    artworks = 'st251q07ja',
    classics = 'st256q02ja',
    lonely = 'st034q06ta',
    computer = 'ic171q01ja',
    cycle = 8
  )
)

safe_Rrepest <- function(df, statistic, target, regressor = NULL, ...) {
  tryCatch({
    df |> Rrepest(est = est(statistic, target, regressor), ...) |> 
      select(-matches('NA', ignore.case = FALSE))
    
  }, error = function(e) {
    # Consider only one plausible value
    new_target <- gsub("@", "1", target)
    message("Second attempt for ", statistic, " with ", new_target)
    
    df |> Rrepest(est = est(statistic, new_target, regressor), ...) |> 
      select(-matches('NA', ignore.case = FALSE))
  })

}

rename_level <- function(df) {
  if (all(df['over'] == "")) {
    df <- rename(df, level = over_level, over_level = concept_level)
  } else {
    df <- rename(df, level = concept_level)
  }
  
  return(df)
}

to_tidy <- function(df, year, over = NULL) {
    df |>
    rename_with( ~ .x |>
                   str_remove_all("pv[\\@\\d+]|^b\\.|\\.y\\.y\\.y\\.y\\.y") |>
                   str_replace_all(
                     c(
                       "^se\\.(?=(level|escsq|hisced|books|artworks|classics|lonely|computer))" = "se.freq.",
                       "^(?=(level|escsq|hisced|books|artworks|classics|lonely|computer))" = "freq.",
                       "escsq" = "escs",
                       "^se\\.(\\w+)" = "\\1_se",
                       'quant0(\\d)' = 'perc_\\10',
                       "(level[\\@\\d+])?math" = "math_score",
                       "(level[\\@\\d+])?read" = "reading_score"
                     )
                   )) |>
    pivot_longer(cols = -area, names_to = c("metric", "concept", "level"), names_pattern = "^([^\\.]+)\\.([^\\.]+)\\.?\\.?(.+)?") |>
    mutate(over = coalesce(over, "") |> str_remove("q$")) |>
    separate(level, into = c("concept_level", "over_level"), sep = "\\.\\.", fill = "left") |>
    rename_level() |>
    mutate(year = year) |>
    select(year, area, concept, over, over_level, level, metric, value) |>
    rename_with(
      .fn = ~ coalesce(over, "temp") |> str_remove("q$"),
      .cols = "over_level"
    ) |>
    select(-over) |>
    select_if(~!(all(is.na(.)) | all(. == "")))
}

# Process each year
for (i in seq_along(years)) {
  year <- years[i]
  message('Processing year ', year)
  
  config <- year_config[[year]]
  
  # Preprocess and harmonize escs for trend analysis
  if (year == '2000') {
    df_math <- read_sav('PISA/2000math.sav') |> 
      select(-contains(c('w_fstr', 'w_fstuwt')))
    df_read <- read_sav('PISA/2000read.sav')
    
    common_cols <- intersect(names(df_math), names(df_read))
    df <- merge(df_math, df_read, by = common_cols, all = TRUE) |>
      filter(cnt %in% countries) |>
      mutate(hisced = pmax(fisced, misced))
    
    rm(df_math, df_read)
    gc()
    
  } else {
    df <- read_sav(paste0('PISA/', year, '.sav')) |>
      filter(CNT %in% countries)
  }
  
  colnames(df) <- tolower(colnames(df))
  
  if ('cntschid' %in% names(df)) {
    df <- df |>
      mutate(schoolid = as.numeric(
        str_sub(as.character(cntschid), 3, -1))
      )
  }
  if ('cntstuid' %in% names(df)) {
    df <- df |>
      mutate(studentid = as.numeric(
        str_sub(as.character(cntstuid), 3, -1))
      )
  }
  
  if (year %in% c('2000', '2022')) {
    df <- df |>
      mutate(!!config$books := case_when(
        .data[[config$books]] == 1 ~ 2,
        TRUE ~ .data[[config$books]]
      ))
  }

  if (year == '2012') {
    df <- df |> mutate(studentid = as.numeric(stidstd))
  }
  
  if (!is.null(config$escs_sav) && config$escs_sav) {
    escs <- read_sav(paste0('PISA/ESCS/', year, '.sav'))
    df <- df |>
      merge(
        escs,
        by = c('cnt', 'schoolid', 'stidstd'),
        all.x = TRUE
      )
    rm(escs)
    gc()
    
    if (year != '2000') {
      df <- df |> select(-'escs')
    }
  }
  
  if (!is.null(config$escs_csv) && config$escs_csv) {
    df <- df |>
      mutate(
        studentid = as.numeric(studentid),
        schoolid = as.numeric(schoolid)
      ) |>
      merge(
        escs_csv[escs_csv$cycle == config$cycle, ],
        by = c('cnt', 'schoolid', 'studentid', 'oecd'),
        all.x = TRUE
      ) |> select(-c('escs', 'hisei'))
  }

  # Rename indicators
  df <- df |>
    rename(
      area = cnt,
      escs = config$escs,
      hisei = config$hisei,
      books = config$books,
      artworks = config$artworks,
      classics = config$classics
    )
  
  # Other indicators
  others <- c('books', 'artworks', 'classics')

  if (!is.null(config$lonely)) {
    df <- df |> rename(lonely = config$lonely)
    others <- c(others, 'lonely')
  }
  
  if (!is.null(config$computer)) {
    df <- df |> rename(computer = config$computer)
    others <- c(others, 'computer')
  }

  # Convert scalar indicators to discrete levels for distribution analysis
  cols <- c('area', 'escs', 'hisei', 'hisced', others)  
  quartiles <- weighted.quant(df[['escs']], w = df$w_fstuwt, q = c(0.25, 0.5, 0.75))

  df <- df |>
    select(all_of(cols), starts_with('pv'), starts_with('w_')) |>
    mutate(
      escsq = case_when(
        escs <= quartiles[1] ~ 1,
        escs <= quartiles[2] ~ 2,
        escs <= quartiles[3] ~ 3,
        escs > quartiles[3] ~ 4
      ) |> 
        labelled(
          labels = c(
            'quart_1' = 1,
            'quart_2' = 2,
            'quart_3' = 3,
            'quart_4' = 4
          )
        ),
      hisced = case_when(
        hisced <= 2 ~ 1,
        hisced <= 4 ~ 2,
        hisced <= 8 ~ 3
      ) |> 
        labelled(
          labels = c(
            'low' = 1,
            'medium' = 2,
            'high' = 3
          )
        ),
      across(
        matches('^pv[0-9]{1,2}math$'),
        .fns = ~ cut(
          .x,
          breaks = c(-Inf, 358, 420, 482, 545, 607, 669, +Inf)
        ) |> 
          labelled(
            labels = c(
              'below_level_1a' = 1,
              'level_1a'       = 2,
              'level_2'        = 3,
              'level_3'        = 4,
              'level_4'        = 5,
              'level_5'        = 6,
              'level_6'        = 7
            )
          ),
        .names = "{str_replace({.col},'^pv','level')}"
      ),
      across(
        matches('^pv[0-9]{1,2}read$'),
        .fns = ~ cut(
          .x,
          breaks = c(-Inf, 335, 407, 480, 553, 626, 698, +Inf)
        ) |> 
          labelled(
            labels = c(
              'below_level_1a' = 1,
              'level_1a'       = 2,
              'level_2'        = 3,
              'level_3'        = 4,
              'level_4'        = 5,
              'level_5'        = 6,
              'level_6'        = 7
            )
          ),
        .names = "{str_replace({.col},'^pv','level')}"
      ),
      area = zap_labels(area)
    )

    if (year == '2022') {
    df <- df |>
      mutate(
        artworks = case_when(
          artworks == 1 ~ 1,
          artworks <= 4 ~ 2
        ) |>
          labelled(
            labels = c(
              'N' = 1,
              'Y' = 2
            )
          ),
        classics = case_when(
          classics == 1 ~ 1,
          classics <= 4 ~ 2
        ) |>
          labelled(
            labels = c(
              'N' = 1,
              'Y' = 2
            )
          )
      )
  }

  # Rename other value labels
  val_labels <- label_map[[as.character(year)]]
  
  df <- df |>
    mutate(across(all_of(others), 
                  ~ labelled(.x, labels = unlist(val_labels[[cur_column()]]))))
  
  # Mean, 10th, 50th and 90th percentiles of scores
  res[['mean_scores']] <- append(res[['mean_scores']], list(
    (
      df |> safe_Rrepest(
        statistic = c('mean', 'quant', 0.1, 'quant', 0.5, 'quant', 0.9),
        target = c('pv1math', 'pv1read'),
        svy = config$survey,
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        by = 'area',
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year)
    )
  ))
 
  # Mean scores over escs quartiles
  res[['mean_scores_escs']] <- append(res[['mean_scores_escs']], list(
    (
      df |> safe_Rrepest(
        statistic = 'mean',
        target = c('pv@math', 'pv@read'),
        svy = config$survey,
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        over = 'escsq',
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year, 'escsq')
    )
  ))

  # Mean scores over parents' education level
  res[['mean_scores_hisced']] <- append(res[['mean_scores_hisced']], list(
    (
      df |> safe_Rrepest(
        statistic = 'mean',
        target = c('pv@math', 'pv@read'),
        svy = config$survey,
        by = 'area',
        test = FALSE,
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        over = 'hisced',
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year, 'hisced')
    )
  ))

  # Mean scores over books
  res[['mean_scores_books']] <- append(res[['mean_scores_books']], list(
    (
      df |> safe_Rrepest(
        statistic = 'mean',
        target = c('pv@math', 'pv@read'),
        svy = config$survey,
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        over = 'books',
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year, 'books')
    )
  ))

  # Mean scores over artworks
  res[['mean_scores_artworks']] <- append(res[['mean_scores_artworks']], list(
    (
      df |> safe_Rrepest(
        statistic = 'mean',
        target = c('pv@math', 'pv@read'),
        svy = config$survey,
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        over = 'artworks',
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year, 'artworks')
    )
  ))

  # Mean scores over classics
  res[['mean_scores_classics']] <- append(res[['mean_scores_classics']], list(
    (
      df |> safe_Rrepest(
        statistic = 'mean',
        target = c('pv@math', 'pv@read'),
        svy = config$survey,
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        over = 'classics',
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year, 'classics')
    )
  ))

  # Mean scores over loneliness
  if (!is.null(config$lonely)) {
    res[['mean_scores_lonely']] <- append(res[['mean_scores_lonely']], list(
      (
        df |> safe_Rrepest(
          statistic = 'mean',
          target = c('pv@math', 'pv@read'),
          svy = config$survey,
          by = 'area',
          flag = FALSE,
          fast = FALSE,
          showna = FALSE,
          over = 'lonely',
          cm.weights = config$weights,
          group = eu
        ) |> to_tidy(year, 'lonely')
      )
    ))
  }

  # Mean scores over computer use
  if (!is.null(config$computer)) {
    res[['mean_scores_computer']] <- append(res[['mean_scores_computer']], list(
      (
        df |> safe_Rrepest(
          statistic = 'mean',
          target = c('pv@math', 'pv@read'),
          svy = config$survey,
          by = 'area',
          flag = FALSE,
          fast = FALSE,
          showna = FALSE,
          over = 'computer',
          cm.weights = config$weights,
          group = eu
        ) |> to_tidy(year, 'computer')
      )
    ))
  }

  # Correlation of math, read, escs, hisei
  res[['corr_scores']] <- append(res[['corr_scores']], list(
    (
      df |> safe_Rrepest(
        statistic = 'corr',
        target = c('pv@math', 'pv@read', 'escs', 'hisei'),
        svy = config$survey,
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        by = 'area',
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year)
    )
  ))

  # Distribution of math and reading levels
  res[['freq_scores']] <- append(res[['freq_scores']], list(
    (
      df |> safe_Rrepest(
        statistic = 'freq',
        target = c('level@math', 'level@read'),
        svy = config$survey,
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year)
    )
  ))

  # Distribution of escs quartiles
  res[['freq_escs']] <- append(res[['freq_escs']], list(
    (
      df |> safe_Rrepest(
        statistic = 'freq',
        target = 'escsq',
        svy = config$survey, 
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year)
    )
  ))

  # Distribution of parents' education level
  res[['freq_hisced']] <- append(res[['freq_hisced']], list(
    (
      df |> safe_Rrepest(
        statistic = 'freq',
        target = 'hisced',
        svy = config$survey, 
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year)
    )
  ))

  # Distribution of math and reading levels over escs quartiles
  res[['freq_scores_escs']] <- append(res[['freq_scores_escs']], list(
    (
      df |> safe_Rrepest(
        statistic = 'freq',
        target = c('level@math', 'level@read'),
        svy = config$survey, 
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        cm.weights = config$weights,
        over='escsq',
        group = eu
      ) |> to_tidy(year, 'escsq')
    )
  ))

  # Distribution of math and reading levels over parents' education level
  res[['freq_scores_hisced']] <- append(res[['freq_scores_hisced']], list(
    (
      df |> safe_Rrepest(
        statistic = 'freq',
        target = c('level@math', 'level@read'),
        svy = config$survey, 
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        cm.weights = config$weights,
        over = 'hisced',
        group = eu
      ) |> to_tidy(year, 'hisced')
    )
  ))

  # Frequency of books, artworks, classics, loneliness, computer use
  res[['freq_books_etc']] <- append(res[['freq_books_etc']], list(
    (
      df |> safe_Rrepest(
        statistic = 'freq',
        target = others,
        svy = config$survey, 
        by = 'area',
        flag = FALSE,
        fast = FALSE,
        showna = FALSE,
        cm.weights = config$weights,
        group = eu
      ) |> to_tidy(year)
    )
  ))
  
  # Save value labels as a json file to apply a custom renaming at the next iteration
  # vals <- NULL
  # for (col in others) {
  #   vals <- c(vals, val_labels(df[col]))
  # }
  # labels[[year]] <- vals |> lapply(as.list)

  rm(df)
  gc()
}

# write_json(labels, "PISA_labels.json", pretty = TRUE, auto_unbox = TRUE)

full_res <- lapply(res, bind_rows)

for (i in seq_along(res_codes)) {
  code <- res_codes[i]
  write.csv(full_res[[code]], paste0('../datasets/source/D1.',i,'_PISA_', code, ".csv"), row.names = FALSE, na = "")
}