from bs4 import BeautifulSoup
from datetime import datetime
from pytz import timezone


def get_released_items(items):
    print("get_released_items...")

    released_items = []

    today = datetime.now(timezone('Asia/Seoul'))
    today_ymd = datetime(year=today.year, month=today.month, day=today.day)
    print('Today Date:', today_ymd)  # 2022-11-11 00:00:00

    for item in items:
        caption = item.find('div', class_='launch-caption')
        m = caption.find('p', class_='headline-4').getText().split('월')[0]  # 1,..8,9..12
        d = caption.find('p', class_='headline-1').getText().split('일')[0]  # 1..31

        item_ymd = datetime(year=today.year, month=int(m), day=int(d))  # 2022-11-11 00:00:00

        if item_ymd <= today_ymd:
            item_info = item.find('figcaption').find('div', class_='copy-container')
            title = item_info.find('h2', class_='headline-5').get_text()
            theme = item_info.find('h3', class_='headline-3').get_text()
            href = item.find('a', class_='card-link').attrs['href']
            img = item.find('img', class_='image-component')
            if img is not None:
                img_src = img.attrs['src']
            else:
                img_src = ""
                print(title, "의 이미지를 찾지 못해 빈 문자열로 대체합니다.")

            print("released_items.append -", title, item_ymd)
            released_items.append({
                'title': title,
                'theme': theme,
                'image': img_src,
                'href': href,
                'date': m + "/" + d,
            })

    print(len(released_items), "개의 출시된 아이템을 찾았습니다.")
    return released_items
