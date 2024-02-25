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

    print("date:", date) # "4.5. 오전 1:00출시"

    splited_string = date.split() # ['4.5.', '오전', '1:00출시']

    month = int(splited_string[0].split(".")[0])
    day = int(splited_string[0].split(".")[1])

    time_string = splited_string[2].replace("출시", "") # "1:00"

    hour = int(time_string.split(":")[0])
    min = int(time_string.split(":")[1])

    # 12시간제 -> 24시간제로 변경
    if "오후" in date and hour < 12:
        hour += 12

    today = datetime.now()

    # 시간대 설정
    tz_utc = pytz.timezone('UTC')

    # UTC datetime 생성
    release_date_datetime = datetime(today.year, int(month), int(day), int(hour), int(min), tzinfo=tz_utc)

    # 타임스탬프 변환
    time_stamp = int(release_date_datetime.timestamp())

    print(release_date_datetime, time_stamp)

    return str(time_stamp)
