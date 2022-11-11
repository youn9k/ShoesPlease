from bs4 import BeautifulSoup

def get_to_be_released_items(items):
    to_be_released_items = []

    for item in items:
        button_text = ''

        if item.find('button', class_='ncss-btn-primary-dark') is None:
            button_text = item.find('a', class_='ncss-btn-primary-dark').get_text()
        else:
            button_text = item.find('button', class_='ncss-btn-primary-dark').get_text()

        if button_text.strip() == 'Coming Soon':
            print("버튼 Text:", button_text)

        if (button_text and button_text.strip() == 'Coming Soon'):
            item_info = item.find('figcaption').find('div', class_='copy-container')
            img = item.find('img', class_='image-component').attrs['src']
            title = item_info.find('h3', class_='headline-5').get_text()
            theme = item_info.find('h6', class_='headline-3').get_text()
            href = item.find('a', class_='card-link').attrs['href']
            month = item.find('div', class_='launch-caption').find('p', class_='headline-4').getText().split('월')[0]
            day = item.find('div', class_='launch-caption').find('p', class_='headline-1').getText().split('일')[0]
            to_be_released_items.append({
                'title': title,
                'theme': theme,
                'image': img,
                'href': href,
                'date': month + "/" + day,
                'releaseDate': ''
            })

    return to_be_released_items
