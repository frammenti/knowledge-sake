library(tidyr)
library(dplyr)
library(stringr)
library(countrycode)

years = c('2000', '2003', '2006', '2009', '2012', '2015', '2018', '2022')

res <- NULL

for (year in years) {
  
  df <- read.csv(paste0('PISA/', year, '.csv'))
  df <- cbind(year = year, df)
  
  df <- df |>
    rename(country = cnt)
  
  iso_mapped <- countrycode(df$country, origin = 'iso3c', destination = 'country.name')
  
  df$country <- ifelse(!is.na(iso_mapped), iso_mapped, df$country) |>
    tolower() |>
    tools::toTitleCase() |>
    str_replace('Czech Republic', 'Czechia') |>
    str_replace('Slovak Republic', 'Slovakia')
  
  colnames(df) <- colnames(df) |>
    tolower() |>
    str_remove_all('^b\\.|pv\\d+|_trend|\\.+$') |>
    str_replace_all('\\.+', '_') |>
    str_remove_all('pv_|pvlevs_|pvlevs\\d|escs_quarts_|_?iscedlevs|_y_y_y_y_y') |>
    str_replace_all('quant0(\\d)','quant\\10') |>
    str_remove('^_')
  
  if (year == '2000') {
    colnames(df)[c(305:316, 343:370)] <- colnames(df)[c(305:316, 343:370)] |>
      str_replace_all(
          c(
          'st37q01' = 'books',
          '(?<=mean_math|mean_read)_' = '_books_',
          '(?<=_)2' = '0_10',
          '(?<=_)3' = '11_25',
          '(?<=_)4' = '26_100',
          '(?<=_)5' = '101_200',
          '(?<=_)6' = '201_500',
          '(?<=_)7' = '500_more'
        )
      )
    
    colnames(df)[c(317:320, 371:382)] <- colnames(df)[c(317:320, 371:382)] |>
      str_replace_all(
        c(
          '_x$' = '',
          'st21q11' = 'artworks',
          '(?<=mean_math|mean_read)_' = '_artworks_'
        )
      )
    
    colnames(df)[c(321:324, 383:394)] <- colnames(df)[c(321:324, 383:394)] |>
      str_replace_all(
        c(
          '_y$' = '',
          'st21q09' = 'classics',
          '(?<=mean_math|mean_read)_' = '_classics_'
        )
      )
    
    colnames(df) <- colnames(df) |>
      str_replace_all(
        c(
          'st31q06' = 'lonely',
          '(?<=mean_math|mean_read)_(?=agree|disagree|strongly)' = '_lonely_',
          'st39q02' = 'computer',
          '(?<=mean_math|mean_read)_(?=few|never|several|once)' = '_computer_',
          'several_times_week' = 'every_day',
          'several_times_month' = 'few_times_week'
        )
      )
  } else if (year == '2003') {
    colnames(df)[c(305:316, 343:370)] <- colnames(df)[c(305:316, 343:370)] |>
      str_replace_all(
        c(
          'st19q01' = 'books',
          '_books' = '',
          '_than' = '',
          '(?<=mean_math|mean_read)_' = '_books_',
          'more_500' = '500_more'
        )
      ) |> str_replace_all('se_(?=\\d)', 'se_books_')
    
    colnames(df)[c(317:320, 371:382)] <- colnames(df)[c(317:320, 371:382)] |>
      str_replace_all(
        c(
          '_x$' = '',
          'st17q10' = 'artworks',
          '(?<=mean_math|mean_read)_' = '_artworks_',
          '(?<=no)_tick' = ''
        )
      ) |> str_replace_all('_tick', '_yes')
    
    colnames(df)[c(321:324, 383:394)] <- colnames(df)[c(321:324, 383:394)] |>
      str_replace_all(
        c(
          '_y$' = '',
          'st17q08' = 'classics',
          '(?<=mean_math|mean_read)_' = '_classics_',
          '(?<=no)_tick' = ''
        )
      ) |> str_replace_all('_tick', '_yes')
    
    colnames(df) <- colnames(df) |>
      str_replace_all(
        c(
          'st27q06' = 'lonely',
          '(?<=mean_math|mean_read)_(?=agree|disagree|strongly)' = '_lonely_',
          'ic04q01' = 'computer',
          '(?<=mean_math|mean_read)_(?=a_few|almost|between|less|never)' = '_computer_',
          'almost_' = '',
          'a_few_times_each_week' = 'few_times_week',
          'between_1_pwk_1_pmn' = 'once_month',
          'less_than_1_pmn' = 'few_times_year'
        )
      )
  } else if (year == '2006') {
    colnames(df)[c(305:316, 335:362)] <- colnames(df)[c(305:316, 335:362)] |>
      str_replace_all(
        c(
          'st15q01' = 'books',
          '_books' = '',
          '_than' = '',
          '(?<=mean_math|mean_read)_' = '_books_',
          'more_500' = '500_more'
        )
      ) |> str_replace_all('se_(?=\\d)', 'se_books_')
    
    colnames(df)[c(317:320, 363:374)] <- colnames(df)[c(317:320, 363:374)] |>
      str_replace_all(
        c(
          '_x$' = '',
          'st13q10' = 'artworks',
          '(?<=mean_math|mean_read)_' = '_artworks_'
        )
      )
    
    colnames(df)[c(321:324, 375:386)] <- colnames(df)[c(321:324, 375:386)] |>
      str_replace_all(
        c(
          '_y$' = '',
          'st13q08' = 'classics',
          '(?<=mean_math|mean_read)_' = '_classics_'
        )
      )
    
    colnames(df) <- colnames(df) |>
      str_replace_all(
        c(
          'ic03q01' = 'computer',
          '(?<=mean_math|mean_read)_(?=almost|few|never|once)' = '_computer_',
          'almost_' = '',
          'once_or_twice_a_week' = 'few_times_week',
          'few_times_a_month' = 'once_month',
          'once_a_month_or_less' = 'few_times_year'
        )
      )
  } else if (year == '2009') {
    colnames(df)[c(305:316, 333:360)] <- colnames(df)[c(305:316, 333:360)] |>
      str_replace_all(
        c(
          'st22q01' = 'books',
          '_books' = '',
          '_than' = '',
          '(?<=mean_math|mean_read)_' = '_books_',
          'more_500' = '500_more'
        )
      ) |> str_replace_all('se_(?=\\d)', 'se_books_')
    
    colnames(df)[c(317:320, 361:372)] <- colnames(df)[c(317:320, 361:372)] |>
      str_replace_all(
        c(
          '_x$' = '',
          'st20q09' = 'artworks',
          '(?<=mean_math|mean_read)_' = '_artworks_'
        )
      )
    
    colnames(df)[c(321:324, 373:384)] <- colnames(df)[c(321:324, 373:384)] |>
      str_replace_all(
        c(
          '_y$' = '',
          'st20q07' = 'classics',
          '(?<=mean_math|mean_read)_' = '_classics_'
        )
      )
    
    colnames(df) <- colnames(df) |>
      str_replace_all(
        c(
          'ic04q06' = 'computer',
          '(?<=mean_math|mean_read)_(?=almost|once|never)' = '_computer_',
          'almost_' = '',
          '_or_hardly_ever' = '',
          'once_or_twice_a_week' = 'few_times_week',
          'once_or_twice_a_month' = 'once_month'
        )
      )
  } else if (year %in% c('2012', '2015', '2018')) {
    colnames(df)[c(305:316, 333:360)] <- colnames(df)[c(305:316, 333:360)] |>
      str_replace_all(
        c(
          'st28q01|st013q01ta' = 'books',
          '_books' = '',
          '_than' = '',
          '(?<=mean_math|mean_read)_' = '_books_',
          'more_500' = '500_more'
        )
      ) |> str_replace_all('se_(?=\\d)', 'se_books_')
    
    colnames(df)[c(317:320, 361:372)] <- colnames(df)[c(317:320, 361:372)] |>
      str_replace_all(
        c(
          '_x$' = '',
          'st26q09|st011q09ta' = 'artworks',
          '(?<=mean_math|mean_read)_' = '_artworks_'
        )
      )
    
    colnames(df)[c(321:324, 373:384)] <- colnames(df)[c(321:324, 373:384)] |>
      str_replace_all(
        c(
          '_y$' = '',
          'st26q07|st011q07ta' = 'classics',
          '(?<=mean_math|mean_read)_' = '_classics_'
        )
      )
    
    colnames(df) <- colnames(df) |>
      str_replace_all(
        c(
          'st87q06|st034q06ta' = 'lonely',
          '(?<=mean_math|mean_read)_(?=agree|disagree|strongly)' = '_lonely_'
        )
      )
  } else if (year == '2022') {
    colnames(df)[c(305:316, 345:372)] <- colnames(df)[c(305:316, 345:372)] |>
      str_replace_all(
        c(
          'st255q01ja' = 'books',
          '(?<=mean_math|mean_read)_' = '_books_',
          '(?<=_)2' = '0_10',
          '(?<=_)3' = '11_25',
          '(?<=_)4' = '26_100',
          '(?<=_)5' = '101_200',
          '(?<=_)6' = '201_500',
          '(?<=_)7' = '500_more'
        )
      )
    
    colnames(df)[373:384] <- colnames(df)[373:384] |>
      str_replace_all(
        c(
          '_x$' = '',
          '(?<=mean_math|mean_read)_' = '_artworks_'
        )
      )
    
    colnames(df)[385:396] <- colnames(df)[385:396] |>
      str_replace_all(
        c(
          '_y$' = '',
          '(?<=mean_math|mean_read)_' = '_classics_'
        )
      )
    
    colnames(df) <- colnames(df) |>
      str_replace_all(
        c(
          'st034q06ta' = 'lonely',
          '(?<=mean_math|mean_read)_(?=agree|disagree|strongly)' = '_lonely_',
          'ic171q01ja' = 'computer',
          '(?<=mean_math|mean_read)_(?=about|every|never|several|this)' = '_computer_',
          '(?<=every_day)_or_almost_every_day' = '',
          'about_once_or_twice_a_week' = 'few_times_week',
          'about_once_or_twice_a_month' = 'once_month',
          '(?<=never)_or_almost_never' = '',
          '(?<=several_times)_a_day' = '_day',
          'this_resource_is_not_available_to_me_outside_of_school' = 'not_available'
        )
      )
  }
  
  if (is.null(res)) {
    res <- df
  } else {
    cat(paste('\n\nAdded new columns from year', year,':\n'))
    print(setdiff(names(df), intersect(names(res), names(df))))
    res <- merge(res, df, all = TRUE)
  }
}

res <- res |>
  rename_with(~ str_c('diff_', .), .cols = c(85, 95, 337, 357, 363, 369)) |>
  rename_with(~ str_c('se_diff', str_sub(., 3)), .cols = c(86, 96, 338, 358, 364, 370))

write.csv(res, '../datasets/source/D1_OECD_PISA.csv', row.names = FALSE)
