import os
import shutil
import zipfile
import requests
import pandas as pd

file = './world_bank_development_indicators/WDIEXCEL.xlsx'
url = 'https://datacatalogfiles.worldbank.org/ddh-published/0037712/DR0045574/WDI_EXCEL_2024_12_16.zip?versionId=2025-01-15T18:08:40.1137708Z'

if not os.path.exists(file):
    target_dir = os.path.dirname(file)
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)

    zip_path = file + '.zip'
    extract_folder = os.path.splitext(file)[0]

    response = requests.get(url, stream=True)
    response.raise_for_status()
    with open(zip_path, 'wb') as f:
        shutil.copyfileobj(response.raw, f)

    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(extract_folder)

    extracted_file = os.path.join(extract_folder, 'WDIEXCEL.xlsx')
    shutil.move(extracted_file, file)

    shutil.rmtree(extract_folder)
    os.remove(zip_path)


#Mashup with World Bank Developpment Indicators

# Use calamine to speed up pandas excel read
# installable using : `pip install python-calamine`
world_bank_df = pd.read_excel(file, sheet_name="Data", engine="calamine")

eurostat_df = pd.read_csv('../datasets/source/D2_undergraduate_enrollment.csv')

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
mashup_df = eurostat_df.merge(world_bank_df, on=['Country', 'Year'], how='left')

# write the mashup data to a csv file
mashup_df.to_csv('../datasets/mashup/MD1_undergraduate_enrollment_wdi.csv')