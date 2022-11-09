from bs4 import BeautifulSoup

def get_released_items(items):
    released_items = []

    for item in items:
        button_text = ''

        if item.find('button', class_='ncss-btn-primary-dark') is None:
            button_text = item.find('a', class_='ncss-btn-primary-dark').get_text()
        else:
            button_text = item.find('button', class_='ncss-btn-primary-dark').get_text()

        #if button_text.strip() == 'Sold Out' or button_text.strip() == 'Buy':
        #    print("버튼 Text:", button_text)

        if button_text and (button_text.strip() == 'Sold Out' or button_text.strip() == 'Buy'):
            item_info = item.find('figcaption').find('div', class_='copy-container')
            img = item.find('img', class_='image-component').attrs['src']
            title = item_info.find('h3', class_='headline-5').get_text()
            theme = item_info.find('h6', class_='headline-3').get_text()
            href = item.find('a', class_='card-link').attrs['href']

            released_items.append({
                'title': title,
                'theme': theme,
                'image': img,
                'href': href
            })

    return released_items