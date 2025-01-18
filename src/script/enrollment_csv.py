import pandas
import csv
import os
import requests
import shutil
import zipfile


datasets = {
    'src/datasets/world_bank_development_indicators/WDIEXCEL.xlsx': 'https://datacatalogfiles.worldbank.org/ddh-published/0037712/DR0045574/WDI_EXCEL_2024_12_16.zip?versionId=2025-01-15T18:08:40.1137708Z',
}

for file, url in datasets.items():
    zip_path = file + '.zip'
    extract_folder = os.path.splitext(file)[0]  # Remove .xlsx to get folder path
    if os.path.exists(file):
        print(f"{file} already exists.")
        continue
    print(f"Downloading {file}...")
    response = requests.get(url, stream=True)
    with open(zip_path, 'wb') as f_out:
        shutil.copyfileobj(response.raw, f_out)
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(extract_folder)
    extracted_file = os.path.join(extract_folder, 'WDIEXCEL.xlsx')
    shutil.move(extracted_file, file)
    shutil.rmtree(extract_folder)
    os.remove(zip_path)
    print(f"{file} downloaded, extracted, and cleaned up.")


# read csv from eurostat degree enrollment
df = pandas.read_csv("src/mashups/degree_enrollment/estat_educ_uoe_ent02_filtered_en.csv")

# only keep certain columns
df = df[['iscedf13','geo','TIME_PERIOD','OBS_VALUE']]

# rename them
df.columns=['Degree','Country','Year','Undergraduate_enrollment']

total = df[df['Degree']=="Total"]

df = df[df['Degree']!="Total"]

total.columns=['Degree','Country','Year','Total']

total = total.drop(columns=['Degree'])

df2 = df.merge(total, on=['Country', 'Year'], how='left')

# Compute percentage based on the undergradute enrollment value per degree and the total number of unrollment
df2['Percentage'] = (df2['Undergraduate_enrollment'] * 100) / df2['Total']

df2 = df2.sort_values(by=['Country', 'Degree', 'Year'])

df2['Undergraduate_enrollment_Lag'] = df.groupby(['Country', 'Degree'])['Undergraduate_enrollment'].shift(1)

df2['Change_rate'] = ((df2['Undergraduate_enrollment'] - df2['Undergraduate_enrollment_Lag'])/df2['Undergraduate_enrollment_Lag']*100)

df2 = df2.dropna(subset=['Change_rate'])

df2['Proportional_Change'] = df2['Undergraduate_enrollment']/df2['Total']*df2['Change_rate']

# Use calamine to speed up pandas excel read
# installable using : `pip install python-calamine`
world_bank_df = pandas.read_excel("src/datasets/world_bank_development_indicators/WDIEXCEL.xlsx",sheet_name="Data", engine="calamine")

# Convert wide format to long format
world_bank_df = world_bank_df.melt(
    id_vars=['Country Name', 'Country Code', 'Indicator Name', 'Indicator Code'],
    var_name='Year',
    value_name='Value'
)

# Ensure Year is an integer
world_bank_df['Year'] = pandas.to_numeric(world_bank_df['Year'], errors='coerce')

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
df3 = df2.merge(world_bank_df, on=['Country', 'Year'], how='left')

# write the mashup data to a csv file
df3.to_csv('src/mashups/MD1_undergraduate_enrollment_wdi.csv')