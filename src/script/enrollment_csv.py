import pandas
import csv


df = pandas.read_csv("/home/alexis/Github/test/knowledge-sake/src/mashups/degree_enrollment/estat_educ_uoe_ent02_filtered_en.csv")

df = df[['iscedf13','geo','TIME_PERIOD','OBS_VALUE']]

df.columns=['Degree','Country','Year','Undergraduate_enrollment']

print(df.head())

total = df[df['Degree']=="Total"]

df = df[df['Degree']!="Total"]

total.columns=['Degree','Country','Year','Total']

total = total.drop(columns=['Degree'])

print(total)

df2 = df.merge(total, on=['Country', 'Year'], how='left')

df2['Percentage'] = (df2['Undergraduate_enrollment'] * 100) / df2['Total']

df2 = df2.sort_values(by=['Country', 'Degree', 'Year'])

print(df2)

df2['Undergraduate_enrollment_Lag'] = df.groupby(['Country', 'Degree'])['Undergraduate_enrollment'].shift(1)

df2['Change_rate'] = ((df2['Undergraduate_enrollment'] - df2['Undergraduate_enrollment_Lag'])/df2['Undergraduate_enrollment_Lag']*100)

# $Undergraduate enrollment$/$Undergraduate enrollment total$*$Field Change rate$

df2 = df2.dropna(subset=['Change_rate'])


df2['Proportional_Change'] = df2['Undergraduate_enrollment']/df2['Total']*df2['Change_rate']

print(df2)

df2.to_csv('src/datasets/university/D1_undergraduate_enrollment.csv')