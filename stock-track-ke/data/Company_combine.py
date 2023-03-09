from NSE_data import *
import requests
class NSECompanyInfo:
    def __init__(self):
        pass

    def get_company_info(self):
        # call to NSE cloner
        #clone = NSEcloner()
        #clone.scrape_nse_website('https://www.nse.co.ke', 'Nairobi Securities Exchange PLC.html')

        # call to NSE scraper
        scraper = NSEDataScraper('./Nairobi Securities Exchange PLC.html')
        companies_shorts = scraper.get_data()

        # call to companies cloner
        #companiesClone = companiesCloner()
        #companiesClone.scrapeCompanies('https://www.nse.co.ke/listed-companies/#', 'companies.html')

        # call to company scraper
        scraper = scrapeCompanies('./companies.html')
        companies = scraper.get_data()

        company_info = {}

        for shorts_dict in companies_shorts:
            found_company = False

            for company_dict in companies:
                if shorts_dict['short_item'] == company_dict['trading_symbol']:
                    full_item = {
                        'company_name': company_dict['company_name'],
                        'trading_symbol': shorts_dict['short_item'],
                        'nseclosing': shorts_dict['nseclosing'],
                        'nsechange': shorts_dict['nsechange'],
                        'image_url': company_dict['image_url'],
                        'time_stamp': shorts_dict['time_stamp']
                    }
                    company_info[company_dict['company_name']] = full_item
                    found_company = True
                    break

            if not found_company:
                full_item = {
                    'company_name': '',
                    'trading_symbol': shorts_dict['short_item'],
                    'nseclosing': shorts_dict['nseclosing'],
                    'nsechange': shorts_dict['nsechange'],
                    'image_url': company_dict['image_url'],
                    'time_stamp': shorts_dict['time_stamp']
                }
                company_info[shorts_dict['short_item']] = full_item

        return company_info

nse_company_info = NSECompanyInfo()
company_info = nse_company_info.get_company_info()
company_number = 1
for company_name, details in company_info.items():
    print(company_number)
    print("Company Name:", company_name)
    print("Trading Symbol:", details['trading_symbol'])
    print("NSE Closing:", details['nseclosing'])
    print("NSE Change:", details['nsechange'])
    print("Image URL:", details['image_url'])
    print("Time Stamp:", details['time_stamp'])
    print()
    company_number+=1
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
for company_name, item in company_info.items():
    company_ref = ref.child(company_name)
    company_ref.update({
        'nseclosing': item['nseclosing'],
        'nsechange': item['nsechange'],
        'time_stamp': item['time_stamp'],
        'image_url': item['image_url']
    })