library(tidyverse)
library(Rrepest)
library(haven)
library(labelled)

# The older files must be downloaded manually from:
# https://webfs.oecd.org/pisa2022/index.html

# Then the .sps control file must be applied to the .txt student dataset to obtain the .sav
# using any open-source spss processor

# From 2015, the .sav files can be downloaded directly with the following commands:
# curl --output 2015.zip "https://webfs.oecd.org/pisa/PUF_SPSS_COMBINED_CMB_STU_QQQ.zip"
# curl --output 2018.zip "https://webfs.oecd.org/pisa2018/SPSS_STU_QQQ.zip"
# curl --output 2022.zip "https://webfs.oecd.org/pisa2022/STU_QQQ_SPSS.zip"

years = c('2000', '2003', '2006', '2009', '2012', '2015', '2018', '2022')

countries <- c('AUT','BEL','BGR','CZE','CYP','DEU','DNK','ESP','EST','FIN',
               'FRA','GBR','GRC','HRV','HUN','IRL','ITA','LTU','LUX','LVA',
               'MLT','NLD','POL','PRT','ROU','SVK','SVN','SWE')

eu <- grp('European Union (28)','cnt', countries)

escs_csv <- read.csv('PISA/ESCS/escs_trend.csv')

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
    artworks = 'artworks',
    classics = 'classics',
    lonely = 'st034q06ta',
    computer = 'ic171q01ja',
    cycle = 8
  )
)

# Process each year
for (i in seq_along(years)) {
  year <- years[i]
  print(paste('Processing', year))
  
  config <- year_config[[year]]
  
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
    df[[config$books]] <- ifelse(df[[config$books]] == 1, 2, df[[config$books]])
  }

  if (year == '2012') {
    df <- df |>
      mutate(studentid = as.numeric(stidstd))
  }
  
  if (!is.null(config$escs_sav) && config$escs_sav) {
    escs <- read_sav(paste0('PISA/ESCS/', year, '.sav'))
    df <- merge(df, escs, by = c('cnt', 'schoolid', 'stidstd'), all.x = TRUE)
    rm(escs)
    gc()
  }
  
  if (!is.null(config$escs_csv) && config$escs_csv) {
    df <- df |>
      mutate(
        studentid = as.numeric(studentid),
        schoolid = as.numeric(schoolid)
      )
    df <- merge(
      df,
      escs_csv[escs_csv$cycle == config$cycle, ],
      by = c('cnt', 'schoolid', 'studentid', 'oecd'),
      all.x = TRUE
    )
  }

  # Other variables
  vars <- list(
    books = config$books,
    artworks = config$artworks,
    classics = config$classics
  )
  
  if (!is.null(config$lonely)) {
    vars$lonely <- config$lonely
  }
  
  if (!is.null(config$computer)) {
    vars$computer <- config$computer
  }

  quartiles <- weighted.quant(df[[config$escs]], w = df$w_fstuwt, q = c(0.25, 0.5, 0.75))
  
  cols <- c('cnt', config$escs, config$hisei, 'hisced', unlist(vars, use.names = FALSE))

  if (year == '2022') {
    df <- df |>
      mutate(
        artworks = case_when(
          st251q07ja == 1 ~ 1,
          st251q07ja <= 4 ~ 2
        ) |>
          labelled(
            labels = c(
              'no' = 1,
              'yes' = 2
            )
          ),
        classics = case_when(
          st256q02ja == 1 ~ 1,
          st256q02ja <= 4 ~ 2
        ) |>
          labelled(
            labels = c(
              'no' = 1,
              'yes' = 2
            )
          )
      )
  }

  df <- df |>
    select(all_of(cols), starts_with('pv'), starts_with('w_')) |>
    mutate(
      escs_quarts = case_when(
        !!sym(config$escs) <= quartiles[1] ~ 1,
        !!sym(config$escs) <= quartiles[2] ~ 2,
        !!sym(config$escs) <= quartiles[3] ~ 3,
        !!sym(config$escs) > quartiles[3] ~ 4
      ) |> 
        labelled(
          labels = c(
            'quart1_escs' = 1,
            'quart2_escs' = 2,
            'quart3_escs' = 3,
            'quart4_escs' = 4
          )
        ),
      iscedlevs = case_when(
        hisced <= 2 ~ 1,
        hisced <= 4 ~ 2,
        hisced <= 8 ~ 3
      ) |> 
        labelled(
          labels = c(
            'low_ed_parent' = 1,
            'medium_ed_parent' = 2,
            'high_ed_parent' = 3
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
              'below_lv1'  = 1,
              'lv1'        = 2,
              'lv2'        = 3,
              'lv3'        = 4,
              'lv4'        = 5,
              'lv5'        = 6,
              'lv6'        = 7
            )
          ),
        .names = "{str_replace({.col},'^pv','pvlevs')}"
      ),
      across(
        matches('^pv[0-9]{1,2}read$'),
        .fns = ~ cut(
          .x,
          breaks = c(-Inf, 335, 407, 480, 553, 626, 698, +Inf)
        ) |> 
          labelled(
            labels = c(
              'below_lv1a' = 1,
              'lv1a'       = 2,
              'lv2'        = 3,
              'lv3'        = 4,
              'lv4'        = 5,
              'lv5'        = 6,
              'lv6'        = 7
            )
          ),
        .names = "{str_replace({.col},'^pv','pvlevs')}"
      )
    )
  
  res <- list()
  
  # Mean and correlation of math, read, escs, hisei
  res[[1]] <- df |> Rrepest(
    svy = config$survey,
    est = est(c('mean', 'corr'), c('pv@math', 'pv@read', config$escs, config$hisei)),
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    by = 'cnt',
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Scores of 10th, 50th and 90th percentiles
  res[[2]] <- df |> Rrepest(
    svy = config$survey,
    est = est(c('quant', 0.1, 'quant', 0.5, 'quant', 0.9), c('pv1math', 'pv1read')),
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    by = 'cnt',
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Distribution of read levels
  res[[3]] <- df |> Rrepest(
    svy = config$survey, 
    est = est('freq', 'pvlevs@read'),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Distribution of math levels
  res[[4]] <- df |> Rrepest(
    svy = config$survey, 
    est = est('freq', 'pvlevs@math'),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Distribution of escs quartiles and parents' highest education
  res[[5]] <- df |> Rrepest(
    svy = config$survey, 
    est = est('freq', c('escs_quarts', 'iscedlevs')),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Mean scores over escs quartiles
  res[[6]] <- df |> Rrepest(
    svy = config$survey,
    est = est('mean', c('pv@math', 'pv@read')),
    by = 'cnt',
    test = TRUE,
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    over = 'escs_quarts',
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Distribution of read levels over escs quartiles
  res[[7]] <- df |> Rrepest(
    svy = config$survey, 
    est = est('freq', 'pvlevs@read'),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    over = 'escs_quarts',
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Distribution of math levels over escs quartiles
  res[[8]] <- df |> Rrepest(
    svy = config$survey, 
    est = est('freq', 'pvlevs@math'),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    over='escs_quarts',
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Mean scores over parents' highest study title
  res[[9]] <- df |> Rrepest(
    svy = config$survey,
    est = est('mean', c('pv@math', 'pv@read')),
    by = 'cnt',
    test = FALSE,
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    over = 'iscedlevs',
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Distribution of read levels over parents' highest study title
  res[[10]] <- df |> Rrepest(
    svy = config$survey, 
    est = est('freq', 'pvlevs@read'),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    over = 'iscedlevs',
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Distribution of math levels over parents' highest study title
  res[[11]] <- df |> Rrepest(
    svy = config$survey, 
    est = est('freq', 'pvlevs@math'),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    over = 'iscedlevs',
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))

  # Frequency of books, artworks, classics, loneliness, computer use
  res[[12]] <- df |> Rrepest(
    svy = config$survey, 
    est = est('freq', vars),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Mean scores over books
  res[[13]] <- df |> Rrepest(
    svy = config$survey,
    est = est('mean', c('pv@math', 'pv@read')),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    test = TRUE,
    showna = FALSE,
    over = config$books,
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Mean scores over artworks
  res[[14]] <- df |> Rrepest(
    svy = config$survey,
    est = est('mean', c('pv@math', 'pv@read')),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    test = TRUE,
    showna = FALSE,
    over = config$artworks,
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Mean scores over classics
  res[[15]] <- df |> Rrepest(
    svy = config$survey,
    est = est('mean', c('pv@math', 'pv@read')),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    test = TRUE,
    showna = FALSE,
    over = config$classics,
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))
  
  # Linear model
  res[[16]] <- df |> Rrepest(
    svy = config$survey,
    est = est('lm', config$escs, c('pv@math', 'pv@read')),
    by = 'cnt',
    flag = FALSE,
    fast = FALSE,
    showna = FALSE,
    cm.weights = config$weights,
    group = eu
  ) |>
    select(-matches('NA', ignore.case = FALSE))

  # Mean scores over loneliness
  if (!is.null(config$lonely)) {
    res <- c(
      res,
      list(
        df |> Rrepest(
          svy = config$survey,
          est = est('mean', c('pv@math', 'pv@read')),
          by = 'cnt',
          flag = FALSE,
          fast = FALSE,
          showna = FALSE,
          over = config$lonely,
          cm.weights = config$weights,
          group = eu
        ) |> 
        select(-matches('NA', ignore.case = FALSE))
      )
    )
  }

  # Mean scores over computer use
  if (!is.null(config$computer)) {
    res <- c(
      res,
      list(
        df |> Rrepest(
          svy = config$survey,
          est = est('mean', c('pv@math', 'pv@read')),
          by = 'cnt',
          flag = FALSE,
          fast = FALSE,
          showna = FALSE,
          over = config$computer,
          cm.weights = config$weights,
          group = eu
        ) |> 
        select(-matches('NA', ignore.case = FALSE))
      )
    )
  }

  res_df <- reduce(res, full_join, by = colnames(res[[1]])[1])
  
  write.csv(res_df, paste0('PISA/', year, '.csv'), row.names = FALSE)
  rm(df, res, res_df)
  gc()
}
