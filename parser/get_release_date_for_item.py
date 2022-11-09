import requests
import lxml
from bs4 import BeautifulSoup

def get_release_date_for_item(href):
    response = requests.get("https://www.nike.com" + href)
    soup = BeautifulSoup(response.text, 'lxml')
    date = soup.find('div', class_='available-date-component').get_text()

    # '11/12 오전 1:00출시 '
    splited = date.split(" ")
    date = splited[0] + " " + splited[2] # "11/12 1:00"

    return date