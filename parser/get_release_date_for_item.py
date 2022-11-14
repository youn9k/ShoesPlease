import requests
import lxml
from bs4 import BeautifulSoup
from datetime import datetime, timezone
from pytz import timezone
import pytz

def get_release_date_for_item(href):
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

    today = datetime.now()

    # 시간대 설정
    tz_utc = pytz.timezone('UTC')

    # UTC datetime 생성
    release_date_datetime = datetime(today.year, int(month), int(day), int(hour), int(min), tzinfo=tz_utc)

    # 타임스탬프 변환
    time_stamp = int(release_date_datetime.timestamp())

    print(release_date_datetime, time_stamp)

    return str(time_stamp)
