from bs4 import BeautifulSoup
from selenium import webdriver
import re
class companiesCloner:
    def __init__(self):
        options = webdriver.ChromeOptions()
        options.add_argument('--headless')
        options.add_argument('--disable_gpu')
        options.add_argument('--no-sandbox')
        options.add_argument('--disable-dev-shm-usage')

        # this creates a new instance of the chrome driver
        self.driver = webdriver.Chrome(options=options)

    def scrapeCompanies(self, url, filename):
        self.driver.get(url)

        with open(filename, 'w') as f:
            f.write(self.driver.page_source)

    def __del__(self):
        self.driver.quit()

#companiesClone = companiesCloner()
#companiesClone.scrapeCompanies('https://www.nse.co.ke/listed-companies/#', 'companies.html')

class scrapeCompanies:
    def __init__(self, html_path):
        self.html_path = html_path

    def get_data(self):
        with open(self.html_path, 'r') as f:
            html = f.read()

        # Parse the HTML using Beautiful Soup
        soup = BeautifulSoup(html, 'html.parser')

        # Find all the company sections in the HTML
        company_sections = soup.find_all('div', {'class': 'vc_col-sm-3'})
        # Loop over each company section and extract the name, trading symbol, and image URL
        companySymbols = []
        for section in company_sections:
            # Find the h6 tag containing the company name
            company_name_tag = section.find('h6', {'style': 'color: #ffffff;'})
            if company_name_tag:
                # Extract the company name from the h6 tag
                company_name = company_name_tag.text.split('Ord')[0].strip()

                # Extract the trading symbol from the following strong tag
                trading_symbol_tag = section.find(text=re.compile('Trading Symbol'))
                if trading_symbol_tag:
                    trading_symbol = trading_symbol_tag.text.split(':')[1].strip()

                    # Extract the image URL from the img tag
                    image_tag = section.find('img')
                    if image_tag:
                        image_url = image_tag['src']

                    # Add the company name, trading symbol, and image URL to a dictionary
                    company = {
                        'company_name': company_name,
                        'trading_symbol': trading_symbol,
                        'image_url': image_url
                    }

                    # Add the dictionary to the list of company symbols
                    companySymbols.append(company)
                    """ for company in companySymbols:
                        print('-----------------------')
                        print(company['company_name'])
                        print(company['trading_symbol'])
                        print(company['image_url'])
                        print('-----------------------') """
        return companySymbols

scraper = scrapeCompanies('./companies.html')
companies = scraper.get_data()

""" companyNumbers = 1
for item in companies:
    print(
        f'{companyNumbers}\n'
        f'company name: {item["company_name"]}\n'
        f'trading_symbol: {item["trading_symbol"]}\n'
    )
    companyNumbers+=1
 """
