from bs4 import BeautifulSoup
from selenium import webdriver

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
        short_items = marquee.find_all('span', {'class': 'shortitems notranslate'})
        nseclosing = marquee.select('[class^="nseclosing"]')
        nsechange = marquee.select('[class^="nsechange"]')

        if len(short_items) == len(nseclosing) == len(nsechange):
            data = []
            for i in range(len(short_items)):
                item = {
                    'short_item': short_items[i].text,
                    'nseclosing': nseclosing[i].text,
                    'nsechange': nsechange[i].text
                }
                data.append(item)
            return data
        else:
            print("Error: length of lists is not the same")

#clone = NSEcloner()
#clone.scrape_nse_website('https://www.nse.co.ke', 'Nairobi Securities Exchange PLC.html')
scraper = NSEDataScraper('./Nairobi Securities Exchange PLC.html')
data = scraper.get_data()
No_of_companies = 1
for item in data:
    print(f'{No_of_companies}\n'
          f'short_item: {item["short_item"]}\n'
          f'nseclosing: {item["nseclosing"]}\n'
          f'nsechange: {item["nsechange"]}\n')
    No_of_companies+=1
del scraper


""" import requests
from bs4 import BeautifulSoup

url = './Nairobi Securities Exchange PLC.html'
response = requests.get('./Nairobi Securities Exchange PLC.html', verify= False)
soup = BeautifulSoup(response.text, 'html.parser')
marquee = soup.find('div', {'id': 'thrnseappend'})
short_items = marquee.find_all('span', {'class': 'shortitems notranslate'})
nseclosing = marquee.find_all('span', {'class': 'nseclosing nsenegative notranslate'})
nsechange = marquee.find_all('span', {'class': 'nsechange nsenegative notranslate'})

for i in range(len(short_items)):
    print(short_items[i].text, nseclosing[i].text, nsechange[i].text) """

""" this is the NSE data scrapper code that works

TODO: put this code as a method in a class

from bs4 import BeautifulSoup

# read the HTML file
with open('./Nairobi Securities Exchange PLC.html', 'r') as f:
    html = f.read()

# create a BeautifulSoup object
soup = BeautifulSoup(html, 'html.parser')

marquee = soup.find('div', {'id': 'thrnseappend'})
short_items = marquee.find_all('span', {'class': 'shortitems notranslate'})
#nseclosing = marquee.find_all('span', {'class': 'nseclosing nsenegative notranslate'})
nseclosing = marquee.select('[class^="nseclosing"]')
#nsechange = marquee.find_all('span', {'class': 'nsechange nsenegative notranslate'})
nsechange = marquee.select('[class^="nsechange"]')

if len(short_items) == len(nseclosing) == len(nsechange):
    for i in range(len(short_items)):
        print(f"{i} {short_items[i].text}, {nseclosing[i].text}, {nsechange[i].text}")
else:
    print("Error: length of lists is not the same") """


""" from selenium import webdriver

# set up the Chrome browser
options = webdriver.ChromeOptions()
options.add_argument('--headless')  # run Chrome in headless mode
options.add_argument('--disable-gpu')
options.add_argument('--no-sandbox')
options.add_argument('--disable-dev-shm-usage')

# create a new instance of the Chrome driver
driver = webdriver.Chrome(options=options)

# navigate to the webpage you want to download
url = 'https://www.nse.co.ke/'
driver.get(url)

# get the page source and save it to a file
with open('Nairobi Securities Exchange PLC.html', 'w') as f:
    f.write(driver.page_source)

# close the browser
driver.quit() """