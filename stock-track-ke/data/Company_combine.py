from NSE_data import *
class NSECompanyInfo:
    def __init__(self):
        pass

    def get_company_info(self):
        # call to NSE cloner
        clone = NSEcloner()
        clone.scrape_nse_website('https://www.nse.co.ke', 'Nairobi Securities Exchange PLC.html')

        # call to NSE scraper
        scraper = NSEDataScraper('./Nairobi Securities Exchange PLC.html')
        companies_shorts = scraper.get_data()

        # call to companies cloner
        companiesClone = companiesCloner()
        companiesClone.scrapeCompanies('https://www.nse.co.ke/listed-companies/#', 'companies.html')

        # call to company scraper
        scraper = scrapeCompanies('./companies.html')
        companies = scraper.get_data()

        full_info = []

        for shorts_dict in companies_shorts:
            found_company = False

            for company_dict in companies:
                if shorts_dict['short_item'] == company_dict['trading_symbol']:
                    full_item = {
                        'company_name': company_dict['company_name'],
                        'trading_symbol': shorts_dict['short_item'],
                        'nseclosing': shorts_dict['nseclosing'],
                        'nsechange': shorts_dict['nsechange'],
                        'time_stamp': shorts_dict['time_stamp']
                    }
                    full_info.append(full_item)
                    found_company = True
                    break

            if not found_company:
                full_item = {
                    'company_name': '',
                    'trading_symbol': shorts_dict['short_item'],
                    'nseclosing': shorts_dict['nseclosing'],
                    'nsechange': shorts_dict['nsechange'],
                    'time_stamp': shorts_dict['time_stamp']
                }
                full_info.append(full_item)

        return full_info

nse_company_info = NSECompanyInfo()
company_info = nse_company_info.get_company_info()

for company_number, item in enumerate(company_info, start=1):
    print(
        f'{company_number}\n'
        f'company name: {item["company_name"]}\n'
        f'trading_symbol: {item["trading_symbol"]}\n'
        f'nseclosing: {item["nseclosing"]}\n'
        f'nsechange: {item["nsechange"]}\n'
        f'time_stamp: {item["time_stamp"]}\n'
    )
# push to database

#from Company_combine import *
import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import time

# Fetch the service account key JSON file contents
cred = credentials.Certificate('auth/stock-track-ke-firebase-adminsdk-2jkhe-45a8dc21a6.json')

# Initialize the app with a service account, granting admin privileges
firebase_admin.initialize_app(cred, {
    'databaseURL': 'https://stock-track-ke-default-rtdb.firebaseio.com'
})

# Get a database reference to a new node called "company_info"
ref = db.reference('company_info')

# Create a list of data to push to the database


# Push the list to the "company_info" node in the database
for company in company_info:
    ref.push(company)