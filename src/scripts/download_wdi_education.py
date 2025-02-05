import wbgapi as wb
import pandas as pd
import os

# Filepath of dataset
file_path_csv = '../datasets/source/D3_WDI_education.csv'
file_path_csv_2 = '../datasets/source/D3_WDI_education_processed.csv'
file_path_correspondance = '../datasets/source/D3_WDI_education_correspondance.csv'
file_path_metadata = '../metadata/D3_WDI_education_metadata.csv'


# indicators and countries to retrieve 
indicators = ['SE.PRM.TENR','SE.PRM.TENR.FE','SE.PRM.TENR.MA','SE.SEC.UNER.LO.ZS','SE.SEC.UNER.LO.FE.ZS','SE.SEC.UNER.LO.MA.ZS','SE.PRM.UNER.ZS','SE.PRM.UNER.FE.ZS','SE.PRM.UNER.MA.ZS','SE.PRM.UNER','SE.PRM.UNER.FE','SE.PRM.UNER.MA','SE.COM.DURS','SE.XPD.CPRM.ZS','SE.XPD.CSEC.ZS','SE.XPD.CTER.ZS','SE.XPD.CTOT.ZS','SE.TER.CUAT.BA.FE.ZS','SE.TER.CUAT.BA.MA.ZS','SE.TER.CUAT.BA.ZS','SE.SEC.CUAT.LO.FE.ZS','SE.SEC.CUAT.LO.MA.ZS','SE.SEC.CUAT.LO.ZS','SE.SEC.CUAT.PO.FE.ZS','SE.SEC.CUAT.PO.MA.ZS','SE.SEC.CUAT.PO.ZS','SE.PRM.CUAT.FE.ZS','SE.PRM.CUAT.MA.ZS','SE.PRM.CUAT.ZS','SE.TER.CUAT.ST.FE.ZS','SE.TER.CUAT.ST.MA.ZS','SE.TER.CUAT.ST.ZS','SE.SEC.CUAT.UP.FE.ZS','SE.SEC.CUAT.UP.MA.ZS','SE.SEC.CUAT.UP.ZS','SE.TER.CUAT.MS.FE.ZS','SE.TER.CUAT.MS.MA.ZS','SE.TER.CUAT.MS.ZS','SE.TER.CUAT.DO.FE.ZS','SE.TER.CUAT.DO.MA.ZS','SE.TER.CUAT.DO.ZS','SE.XPD.PRIM.ZS','SE.XPD.SECO.ZS','SE.XPD.TERT.ZS','SE.LPV.PRIM.SD.FE','SE.LPV.PRIM.LD.FE','SE.XPD.TOTL.GD.ZS','SE.XPD.TOTL.GB.ZS','SE.XPD.PRIM.PC.ZS','SE.XPD.SECO.PC.ZS','SE.XPD.TERT.PC.ZS','SE.PRM.GINT.FE.ZS','SE.PRM.GINT.MA.ZS','SE.PRM.GINT.ZS','SE.LPV.PRIM','SE.LPV.PRIM.FE','SE.LPV.PRIM.MA','SE.ADT.LITR.FE.ZS','SE.ADT.LITR.MA.ZS','SE.ADT.LITR.ZS','SE.ADT.1524.LT.FM.ZS','SE.ADT.1524.LT.FE.ZS','SE.ADT.1524.LT.MA.ZS','SE.ADT.1524.LT.ZS','SE.SEC.CMPT.LO.FE.ZS','SE.SEC.CMPT.LO.MA.ZS','SE.SEC.CMPT.LO.ZS','SE.SEC.AGES','SE.LPV.PRIM.SD.MA','SE.LPV.PRIM.LD.MA','SE.PRM.NINT.ZS','SE.PRM.NINT.FE.ZS','SE.PRM.NINT.MA.ZS','SE.PRM.OENR.ZS','SE.PRM.OENR.FE.ZS','SE.PRM.OENR.MA.ZS','SE.PRM.PRS5.FE.ZS','SE.PRM.PRS5.MA.ZS','SE.PRM.PRS5.ZS','SE.PRM.PRSL.FE.ZS','SE.PRM.PRSL.MA.ZS','SE.PRM.PRSL.ZS','SE.PRE.DURS','SE.PRM.CMPT.FE.ZS','SE.PRM.CMPT.MA.ZS','SE.PRM.CMPT.ZS','SE.PRM.DURS','SE.PRM.ENRL','SE.PRM.ENRL.FE.ZS','SE.PRM.TCHR','SE.PRM.TCHR.FE.ZS','SE.LPV.PRIM.SD','SE.PRM.AGES','SE.SEC.PROG.ZS','SE.SEC.PROG.FE.ZS','SE.SEC.PROG.MA.ZS','SE.SEC.ENRL.LO.TC.ZS','SE.PRE.ENRL.TC.ZS','SE.PRM.ENRL.TC.ZS','SE.SEC.ENRL.TC.ZS','SE.TER.ENRL.TC.ZS','SE.SEC.ENRL.UP.TC.ZS','SE.LPV.PRIM.LD','SE.PRM.REPT.FE.ZS','SE.PRM.REPT.MA.ZS','SE.PRM.REPT.ZS','SE.PRE.ENRR','SE.PRE.ENRR.FE','SE.PRE.ENRR.MA','SE.PRM.ENRR','SE.PRM.NENR','SE.ENR.PRIM.FM.ZS','SE.ENR.PRSC.FM.ZS','SE.PRM.ENRR.FE','SE.PRM.NENR.FE','SE.PRM.ENRR.MA','SE.PRM.NENR.MA','SE.PRM.PRIV.ZS','SE.SEC.ENRR','SE.SEC.NENR','SE.ENR.SECO.FM.ZS','SE.SEC.ENRR.FE','SE.SEC.NENR.FE','SE.SEC.ENRR.MA','SE.SEC.NENR.MA','SE.SEC.PRIV.ZS','SE.TER.ENRR','SE.ENR.TERT.FM.ZS','SE.TER.ENRR.FE','SE.TER.ENRR.MA','SE.SEC.DURS','SE.SEC.ENRL.GC','SE.SEC.ENRL.GC.FE.ZS','SE.SEC.ENRL','SE.SEC.ENRL.FE.ZS','SE.SEC.TCHR','SE.SEC.TCHR.FE.ZS','SE.SEC.TCHR.FE','SE.SEC.ENRL.VO','SE.SEC.ENRL.VO.FE.ZS','SE.TER.TCHR.FE.ZS','SE.SEC.TCAQ.LO.ZS','SE.SEC.TCAQ.LO.FE.ZS','SE.SEC.TCAQ.LO.MA.ZS','SE.PRE.TCAQ.ZS','SE.PRE.TCAQ.FE.ZS','SE.PRE.TCAQ.MA.ZS','SE.PRM.TCAQ.ZS','SE.PRM.TCAQ.FE.ZS','SE.PRM.TCAQ.MA.ZS','SE.SEC.TCAQ.ZS','SE.SEC.TCAQ.FE.ZS','SE.SEC.TCAQ.MA.ZS','SE.SEC.TCAQ.UP.ZS','SE.SEC.TCAQ.UP.FE.ZS','SE.SEC.TCAQ.UP.MA.ZS']
countries = ['AUT','BEL','BGR','HRV','CYP','CZE','DNK','SWE','EST','FIN','FRA','DEU','GRC','HUN','IRL','ITA','LVA','LTU','LUX','NLD','POL','PRT','ROU','SVK','SVN','ESP','GBR','EUU','MLT']

def download_source_dataset():
    if not os.path.exists(file_path_csv):
        print(f"Source dataset {file_path_csv.split('/')[-1]} doesn't exist, downloading ...")

        df = wb.data.DataFrame(indicators, countries,time=range(1970, 2023))

        df.to_csv(file_path_csv)

        print(f"Finished downloading and writing the dataset to {file_path_csv}.")
    elif os.path.exists(file_path_csv):
        df = pd.read_csv(file_path_csv)
        print(f"Dataset {file_path_csv} found.")
    return df

def download_indicators_correspondance():
    if not os.path.exists(file_path_correspondance):
        # Fetch the first batch of indicators (first 5 indicators)
        first = wb.series.info(indicators[0:5])

        # Convert the result into a dictionary and extract the 'items' attribute
        table_dict = vars(first)
        df_series = pd.DataFrame(table_dict.get('items'))

        # Loop through the remaining indicators in batches of 5
        for i in range(5, len(indicators), 5):  # Use integer steps of 5
            info_i = wb.series.info(indicators[i:i+5])
            
            # Convert the result into a dictionary and extract 'items'
            table_dict = vars(info_i)
            df_i = pd.DataFrame(table_dict.get('items'))
            
            # Concatenate the current batch to the main DataFrame
            df_series = pd.concat([df_series, df_i], ignore_index=True)
        df_series.to_csv(file_path_correspondance,index=False)
        print(f"Finished downloading and writing the dataset to {file_path_correspondance}.")
    elif os.path.exists(file_path_correspondance):
        df_series = pd.read_csv(file_path_correspondance)
        print(f"Dataset {file_path_correspondance} found.")
    return df_series


def process_dataset():
    df = download_source_dataset()
    df_series = download_indicators_correspondance()

    # Merge the data with the series correspondence DataFrame
    merged_df = df.merge(df_series, left_on="series", right_on="id", how="left").drop(columns=["id"])

    # Rename year columns by stripping 'YR'
    merged_df.columns = merged_df.columns.str.lstrip('YR')

    # Reorder columns to place 'value' next to 'series'
    cols = merged_df.columns.tolist()
    cols.insert(cols.index("series") + 1, cols.pop(cols.index("value")))
    merged_df = merged_df[cols]

    # Save the processed dataset
    merged_df.to_csv(file_path_csv_2,index=False)
    print(f"Saved the processed dataset to {file_path_csv_2}")

def download_metadata():
    if not os.path.exists(file_path_metadata):
        # Dictionary to store metadata
        metadata_dict = {}

        # Loop through each indicator and fetch metadata
        for ind in indicators:
            metadata_dict[ind] = vars(wb.series.metadata.get(ind))  # Get metadata for one indicator

        # Convert dictionary to DataFrame
        metadata_df = pd.DataFrame(metadata_dict).T.drop(['concept','name'],axis=1)  # Transpose to make indicators rows

        metadata_expanded = pd.json_normalize(metadata_df['metadata'])

        metadata_df.set_index('id', inplace=True)
        metadata_expanded.set_index(metadata_df.index, inplace=True)

        # Combine the 'id' column with the expanded metadata DataFrame
        df_expanded = pd.concat([metadata_df, metadata_expanded], axis=1).drop('metadata',axis=1)

        # Save to CSV
        df_expanded.to_csv(file_path_metadata, index=True)
        print(f"Saved the metadata dataset to {file_path_metadata}")
    elif os.path.exists(file_path_metadata):
        df_expanded = pd.read_csv(file_path_metadata)
        print(f"Dataset {file_path_metadata} found.")
    return df_expanded

process_dataset()
download_metadata()