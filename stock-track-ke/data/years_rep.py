import os
import glob
import pandas as pd
class DataRefresher:
    def __init__(self):
        self.company_folder = f'./company'  # Assumes the 2022 folder is named "Year2022"
        self.yearly_folder = f"./yearly"
        self.company_files = os.listdir(self.company_folder)  # List all files in the 2022 folder

        self.company_names = [f.split('.')[0] for f in self.company_files if f.endswith('.csv')]
        print(self.company_names)
        self.years = list(range(2006, 2023))

        self.df_list = []
    def refresh_data(self):
        for year in self.years:
            # Construct the full path
            year_folder = os.path.join(self.yearly_folder, f"{year}")
            for company in self.company_names:
                files = glob.glob(os.path.join(f"./yearly",f"{year}", f"{company}.csv"))
                if files:
                    print(f"Processing {company}.csv in Year{year}")
                    df = pd.concat([pd.read_csv(f) for f in files])
                    self.df_list.append(df)
                else:
                    print(f"No files found for {company}.csv in Year {year}")

        final_df = pd.concat(self.df_list)
        return final_df

stock_data = DataRefresher()
df = stock_data.refresh_data()
print(df.head())
print("***************************************")
print(df.tail())
