from bs4 import BeautifulSoup
from datetime import datetime
from pytz import timezone


def get_to_be_released_items(items):
    print("get_to_be_released_items...")

    to_be_released_items = []

    today = datetime.now(timezone('Asia/Seoul'))
    today_ymd = datetime(year=today.year, month=today.month, day=today.day)
    print('Today Date:', today_ymd)  # 2022-11-11 00:00:00

    for item in items:
        caption = item.find('div', class_='launch-caption')
        m = caption.find('p', class_='headline-4').getText().split('월')[0]  # 1,..8,9..12
        d = caption.find('p', class_='headline-1').getText().split('일')[0]  # 1..31

        item_ymd = datetime(year=today.year, month=int(m), day=int(d))  # 2022-11-11 00:00:00

        if item_ymd > today_ymd:
            item_info = item.find('figcaption').find('div', class_='copy-container')
            img = item.find('img', class_='image-component').attrs['src']
            title = item_info.find('h3', class_='headline-5').get_text()
            theme = item_info.find('h6', class_='headline-3').get_text()
            href = item.find('a', class_='card-link').attrs['href']

            print("to_be_released_items.append -", title, item_ymd)
            to_be_released_items.append({
                'title': title,
                'theme': theme,
                'image': img,
                'href': href,
                'date': m + "/" + d,  # 9/5
                'releaseDate': ''  # 1668441600 UTC 타임스탬프
            })

    return to_be_released_items
