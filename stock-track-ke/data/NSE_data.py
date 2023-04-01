from bs4 import BeautifulSoup
from selenium import webdriver
import datetime
from NSE_companies import companiesCloner, scrapeCompanies


class NSEcloner:
    """TODO: to run this class
    scraper = NSEScraper()
scraper.scrape_nse_website('https://www.nse.co.ke/', 'Nairobi Securities Exchange PLC.html')
del scraper - this deletes the object and closes the chrome browser.
"""

    def __init__(self):
        # to set up the Chrome browser
        options = webdriver.ChromeOptions()
        options.add_argument('--headless')  # run Chrome in headless mode
        options.add_argument('--disable-gpu')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')

        # create a new instance of the Chrome driver
        self.driver = webdriver.Chrome(options=options)

    def scrape_nse_website(self, url, filename):
        # navigate to the webpage you want to download
        self.driver.get(url)

        # get the page source and save it to a file
        with open(filename, 'w') as f:
            f.write(self.driver.page_source)

    def __del__(self):
        # close the browser
        self.driver.quit()


class NSEDataScraper:
    def __init__(self, html_path):
        self.html_path = html_path
        """ to run this scrapper use 
        scraper = NSEDataScraper('./Nairobi Securities Exchange PLC.html')
        data = scraper.get_data()
        print(data)
        """

    def get_data(self):
        with open(self.html_path, 'r') as f:
            html = f.read()
        soup = BeautifulSoup(html, 'html.parser')
        marquee = soup.find('div', {'id': 'thrnseappend'})
        short_items = marquee.find_all(
            'span', {'class': 'shortitems notranslate'})
        nseclosing = marquee.select('[class^="nseclosing"]')
        nsechange = marquee.select('[class^="nsechange"]')
        # time stamping
        now = datetime.datetime.now()
        timestamp = now.strftime("%d-%m-%Y at %H:%M:%S")

        if len(short_items) == len(nseclosing) == len(nsechange):
            data = []
            for i in range(len(short_items)):
                item = {
                    'short_item': short_items[i].text,
                    'nseclosing': nseclosing[i].text,
                    'nsechange': nsechange[i].text,
                    'time_stamp': timestamp
                }
                data.append(item)
            return data
        else:
            print("Error: length of lists is not the same")

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
                    'company_name': shorts_dict['short_item'],
                    'trading_symbol': shorts_dict['short_item'],
                    'nseclosing': shorts_dict['nseclosing'],
                    'nsechange': shorts_dict['nsechange'],
                    'time_stamp': shorts_dict['time_stamp']
                }
                full_info.append(full_item)

        return full_info


""" # call to NSE cloner
clone = NSEcloner()
clone.scrape_nse_website('https://www.nse.co.ke', 'Nairobi Securities Exchange PLC.html')
# call to NSE scraper
scraper = NSEDataScraper('./Nairobi Securities Exchange PLC.html')
companies_shorts = scraper.get_data()
No_of_companies = 1
print(f'************company and stock details***************************')
for item in companies_shorts:
    print(
        f'{No_of_companies}\n'
        f'short_item: {item["short_item"]}\n'
        f'nseclosing: {item["nseclosing"]}\n'
        f'nsechange: {item["nsechange"]}\n'
        f'time_stamp: {item["time_stamp"]}\n'
    )
    No_of_companies += 1
print(f'*********************************end****************************')
del scraper

# call to companies cloner
companiesClone = companiesCloner()
companiesClone.scrapeCompanies(
    'https://www.nse.co.ke/listed-companies/#', 'companies.html')

# call to company scraper
scraper = scrapeCompanies('./companies.html')
companies = scraper.get_data()
companyNumbers = 1
print(f'***************************company name and symbols************************')
for item in companies:
    print(
        f'{companyNumbers}\n'
        f'company name: {item["company_name"]}\n'
        f'trading_symbol: {item["trading_symbol"]}\n'
    )
    companyNumbers += 1
print(f'**************************end**********************************************')

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

print(f'***************************combined list************************')
companyNumber = 1
for item in full_info:
    print(
        f'{companyNumber}\n'
        f'company name: {item["company_name"]}\n'
        f'trading_symbol: {item["trading_symbol"]}\n'
        f'nseclosing: {item["nseclosing"]}\n'
        f'nsechange: {item["nsechange"]}\n'
        f'time_stamp:{item["time_stamp"]}\n'
    )
    companyNumber += 1
print(f'**************************end**********************************************')
 """
""" full_info = []
for shorts_dict in companies_shorts:
    for company_dict in companies:
        if shorts_dict['short_item'] == company_dict['trading_symbol']:
            full_item = {
                'company_name': company_dict['company_name'],
                'trading_symbol': shorts_dict['short_item'],
                'nseclosing': shorts_dict['nseclosing'],
                'nsechange': shorts_dict['nsechange'],
                'time_stamp': shorts_dict['time_stamp']
            }

            full_info.append(full_item)"""