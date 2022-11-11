import requests
import lxml
from bs4 import BeautifulSoup
from datetime import datetime
from pytz import timezone


def get_release_date_for_item(href):
    today = datetime.now(timezone('Asia/Seoul'))
    response = requests.get("https://www.nike.com" + href)
    soup = BeautifulSoup(response.text, 'lxml')
    date = soup.find('div', class_='available-date-component').get_text()

    # '11/12 오전 1:00출시 '
    splited = date.split(" ")
    date = splited[0] + " " + splited[2]  # "11/12 1:00출시"

    month_day = date.split(" ")[0]  # "11/12"
    hour_min = date.split(" ")[1].split("출시")[0]  # "1:00"

    month = month_day.split("/")[0]  # "11"
    day = month_day.split("/")[1]  # "12"

    hour = hour_min.split(":")[0]  # "1"
    min = hour_min.split(":")[1]  # "00"

    # "2022-09-14-13:05"
    formatted_date = "%d-%02d-%02d %02d:%02d" % (today.year, int(month), int(day), int(hour), int(min))

    return formatted_date
