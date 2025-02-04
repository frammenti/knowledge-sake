import pandas as pd
import json
from pprint import pprint
import datetime
import copy
import itertools

maps = {
    'concept': {
        'mean_math': 0, 'se_mean_math': 1, 'quant10_math': 2,
        'se_quant10_math': 3, 'quant50_math': 4, 'se_quant50_math': 5,
        'quant90_math': 6, 'se_quant90_math': 7, 'mean_read': 8,
        'se_mean_read': 9, 'quant10_read': 10, 'se_quant10_read': 11,
        'quant50_read': 12, 'se_quant50_read': 13, 'quant90_read': 14,
        'se_quant90_read': 15, 'mean_escs': 16, 'se_mean_escs': 17,
        'mean_hisei': 18, 'se_mean_hisei': 19, '': 20, 'se_': 21},
    'year': [2000, 2003, 2006, 2009, 2012, 2015, 2018, 2022],
    'country': ['Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Czechia', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'United Kingdom', 'European Union (28)'],
    'math': ['math_below_lv1', 'math_lv1', 'math_lv2', 'math_lv3', 'math_lv4', 'math_lv5', 'math_lv6'],
    'read': ['read_below_lv1a', 'read_lv1a', 'read_lv2', 'read_lv3', 'read_lv4', 'read_lv5', 'read_lv6'],
    'escs': ['quart1_escs', 'quart2_escs', 'quart3_escs', 'quart4_escs'],
    'hisced': ['low_ed_parent', 'medium_ed_parent', 'high_ed_parent'],
    'books': ['books_0_10', 'books_11_25', 'books_26_100', 'books_101_200', 'books_201_500', 'books_500_more'],
    'artworks': ['artworks_no', 'artworks_yes'],
    'classics': ['classics_no', 'classics_yes'],
    'computer': ['computer_not_available', 'computer_never', 'computer_few_times_year', 'computer_once_month',
                 'computer_few_times_week', 'computer_every_day', 'computer_several_times_day'],
    'lonely': ['lonely_strongly_disagree', 'lonely_disagree', 'lonely_agree', 'lonely_strongly_agree']
}

def filter_category(category, concepts):
    return {key: value for key, value in category.items() if key in concepts}

df_full = pd.read_csv('../datasets/source/D1_secondary_education.csv')

with open('pisa_schema.json') as f:
    full_schema = json.load(f)

df_full['year'] = df_full['year'].map({e: i for i, e in enumerate(maps['year'])})
df_full['area'] = df_full['country'].map({e: i for i, e in enumerate(maps['country'])})
dfs = {'math': pd.DataFrame(), 'read': pd.DataFrame()}
prefixes = ['', 'se_']

for test in dfs.keys():
    cols = {f'{prefix}{col2}_{col1}': (escs, level, maps['concept'][prefix]) for prefix in prefixes for level, col2, in enumerate(maps[test]) for escs, col1 in enumerate(maps['escs'])}
    cols.update({ f'{prefix}{'_' if not prefix.endswith('_') and len(prefix) > 0 else ''}{col}': (escs, 9, maps['concept'][prefix]) for prefix in prefixes + [f'mean_{test}', f'se_mean_{test}'] for escs, col in enumerate(maps['escs'])})
    cols.update({ f'{prefix}{col}': (9, level, maps['concept'][prefix]) for prefix in prefixes for level, col, in enumerate(maps[test])})
        
    assert(len(df_full[list(cols.keys())].columns) == len(cols))
    cols = sorted(cols.items(), key=lambda tup: tup[1])
    teststr = 'reading' if test == 'read' else 'math'

    for col, (quartile, level, concept) in cols:
        temp = pd.DataFrame()
        temp ['year'] = df_full['year']
        temp['area'] = df_full['area']
        temp['escs'] = quartile
        temp[f'{teststr}_level'] = level
        temp['concept'] = concept
        temp['value'] = df_full[col]
        dfs[test] = pd.concat([dfs[test], temp], join='outer')
    
    df = dfs[test]
    schema = copy.deepcopy(full_schema)
    schema['link']['related'] = schema['link'].pop('alternate')
    dimensions = df.columns.to_list()[:-1]
    schema['updated'] = datetime.date.today().isoformat()
    schema['label'] = f'{teststr.capitalize()} Proficiency by Socio-Economic Status'
    schema['id'] = dimensions
    schema['dimension'] = {key: schema['dimension'][key] for key in dimensions}
    concept = schema['dimension']['concept']
    concepts = [key for key, value in concept['category']['index'].items() if value in df['concept'].unique()]
    concept['extension']['definition'] = {key: value for key, value in concept['extension']['definition'].items() if key in concepts}
    for cat in ['index', 'label', 'unit']:
        concept['category'][cat] = filter_category(concept['category'][cat], concepts)
    cube_list = [[val for val in schema['dimension'][dimension]['category']['index'].values()] for dimension in dimensions]
    cube_df = pd.DataFrame(itertools.product(*cube_list), columns=dimensions)
    df = df.merge(cube_df, how='outer')
    schema['size'] = [df[col].nunique() for col in dimensions]
    schema['value'] = [val if not pd.isna(val) else None for val in df['value']]
    size = 1
    for num in schema['size']:
        size *= num
    assert len(df['value']) == size
    with open(f'../datasets/source/D1.1_{test}_escs.json', 'w') as f:
        json.dump(schema, f, indent=4)
    