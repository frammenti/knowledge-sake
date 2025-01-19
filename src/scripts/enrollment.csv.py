import requests
import pandas as pd
import os
import shutil
import zipfile

# Get the dataset through the API
url = 'https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/educ_uoe_ent02/A.NR.TOTAL+F01+F02+F03+F04+F05+F06+F07+F08+F09+F10.ED6.T.EU27_2020+EU28+BE+BG+CZ+DK+DE+EE+IE+EL+ES+FR+HR+IT+CY+LV+LT+LU+HU+MT+NL+AT+PL+PT+RO+SI+SK+FI+SE+UK?format=SDMX-CSV&lang=en&label=label_only&startPeriod=2013'
file_path = 'estat_educ_uoe_ent02_ed6.csv'

try:
    response = requests.get(url)
    response.raise_for_status()
    
    with open(file_path, 'wb') as file:
        file.write(response.content)

except requests.exceptions.RequestException as e:
    print(f'An error occurred: {e}')

df = pd.read_csv(file_path)

# Rename and filter columns
df = df[['iscedf13','geo','TIME_PERIOD','OBS_VALUE']]
df.columns = ['Field (ISCED-F 2013)','Country','Year','Absolute Enrollments']

# Unify data for EU
EU_28 = 'European Union - 28 countries (2013-2020)'
EU_27 = 'European Union - 27 countries (from 2020)'

EU_df = df[df['Country'] == EU_28].merge(
   df[df['Country'] == EU_27],
    on=['Year', 'Field (ISCED-F 2013)'],
    suffixes=('', '_27'),
    how='outer',
)

EU_df['Absolute Enrollments'] = EU_df['Absolute Enrollments'].combine_first(EU_df['Absolute Enrollments_27'])

EU_df.Country = 'European Union'
EU_df = EU_df[df.columns]

df = df[~df['Country'].isin([EU_28, EU_27])]
df = pd.concat([df, EU_df], ignore_index=True)

# Extract total as separate column
total_df = df[df['Field (ISCED-F 2013)'] == 'Total']
df = df[df['Field (ISCED-F 2013)'] != 'Total']

total_df = total_df.drop(columns=['Field (ISCED-F 2013)']) \
			 	   .rename(columns={'Absolute Enrollments': 'Total'})
df = df.merge(total_df, on=['Country', 'Year'], how='left')

# Compute percentage
df['Distribution (%)'] = (df['Absolute Enrollments'] * 100) / df['Total']

# Compute weighted growth rate
df = df.sort_values(by=['Country', 'Field (ISCED-F 2013)', 'Year'])

df['Prev'] = df.groupby(['Country', 'Field (ISCED-F 2013)'])['Absolute Enrollments'].shift(1)

# Avoid dividing by 0
df['Enrollment Growth Rate (%)'] = df.apply(
    lambda row: (row['Absolute Enrollments'] - row['Prev']) / row['Prev'] * 100
    if row['Prev'] > 0 else None,
    axis=1
)

df['Weight'] = df.groupby(['Country', 'Field (ISCED-F 2013)'])['Absolute Enrollments'].shift(1) / df['Total']

# Backfill thrid year weights for second years
df['Weight'] = df.groupby(['Country', 'Field (ISCED-F 2013)'])['Weight'].bfill()

df['Weighted Enrollment Growth Rate (%)'] = df['Weight'] * df['Enrollment Growth Rate (%)']

df = df.drop(columns=['Prev', 'Weight'])

# Final sort
df['Priority'] = df['Country'].apply(lambda x: 0 if x == 'European Union' else 1)
df = df.sort_values(by=['Priority', 'Country', 'Field (ISCED-F 2013)', 'Year'])
df = df.drop(columns=['Priority'])

# Check that the summation of weighted growth rates corresponds to the total growth rate
total_check_df = df[['Country', 'Year', 'Total']]
total_check_df = total_check_df[~total_check_df.duplicated()]

total_check_df['Prev'] = total_check_df.groupby(['Country'])['Total'].shift(1)
total_check_df = total_check_df.dropna(subset=['Prev'])
total_check_df['Total Growth Rate'] = ((total_check_df['Total'] - total_check_df['Prev']) / total_check_df['Prev']) * 100

total_check_df = total_check_df[['Country', 'Year', 'Total Growth Rate']].set_index(['Country', 'Year'])

sum_check = df.groupby(['Country', 'Year'])['Weighted Enrollment Growth Rate (%)'].sum().to_frame()

check_df = sum_check.join(total_check_df)

check_df['Diff'] = abs(check_df['Weighted Enrollment Growth Rate (%)'] - check_df['Total Growth Rate'])

check_df = check_df.dropna(subset=['Diff'])

assert (check_df['Diff'] < 10).all(), "The difference between the sum of weighted growth rates and the total growth rate is 10 or greater in some countries!"


df.to_csv('../datasets/university/D2.1_undergraduate_enrollment.csv')


file = '../datasets/world_bank_development_indicators/WDIEXCEL.xlsx'
url = 'https://datacatalogfiles.worldbank.org/ddh-published/0037712/DR0045574/WDI_EXCEL_2024_12_16.zip?versionId=2025-01-15T18:08:40.1137708Z'

if not os.path.exists(file):
    print(f"{file} not found, downloading it")
    zip_path, extract_folder = file + '.zip', os.path.splitext(file)[0]
    with open(zip_path, 'wb') as f: shutil.copyfileobj(requests.get(url, stream=True).raw, f)
    with zipfile.ZipFile(zip_path, 'r') as zip_ref: zip_ref.extractall(extract_folder)
    shutil.move(os.path.join(extract_folder, 'WDIEXCEL.xlsx'), file)
    shutil.rmtree(extract_folder)
    os.remove(zip_path)
    print(f"{file} downloaded and ready.")
else:
    print(f"{file} already exists.")


#Mashup with World Bank Developpment Indicators

# Use calamine to speed up pandas excel read
# installable using : `pip install python-calamine`
world_bank_df = pd.read_excel("../datasets/world_bank_development_indicators/WDIEXCEL.xlsx",sheet_name="Data", engine="calamine")

# Convert wide format to long format
world_bank_df = world_bank_df.melt(
    id_vars=['Country Name', 'Country Code', 'Indicator Name', 'Indicator Code'],
    var_name='Year',
    value_name='Value'
)

# Ensure Year is an integer
world_bank_df['Year'] = pd.to_numeric(world_bank_df['Year'], errors='coerce')

# Rename columns for consistency
world_bank_df = world_bank_df.rename(columns={'Country Name': 'Country'})

# Filter for relevant indicators
indicators = [
    'School enrollment, tertiary (% gross)',
    'Expenditure on tertiary education (% of government expenditure on education)',
    'Individuals using the Internet (% of population)'
]
world_bank_df = world_bank_df[world_bank_df['Indicator Name'].isin(indicators)]

# Handle duplicates by averaging values (if needed)
world_bank_df = world_bank_df.groupby(['Country', 'Year', 'Indicator Name'], as_index=False)['Value'].mean()

# Pivot to make each indicator a column
world_bank_df = world_bank_df.pivot(index=['Country', 'Year'], columns='Indicator Name', values='Value').reset_index()

# Rename columns for clarity
world_bank_df.columns = ['Country', 'Year', 'Tertiary Enrollment (%)','Government expenditure on tertiary education (%)','Individuals using the Internet (%)']

# Merge both datasets on 'Country' and 'Year'
df3 = df.merge(world_bank_df, on=['Country', 'Year'], how='left')

# write the mashup data to a csv file
df3.to_csv('../mashups/MD1_undergraduate_enrollment_wdi.csv')