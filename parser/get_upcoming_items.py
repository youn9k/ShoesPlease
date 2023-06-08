from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup
import time


def get_upcoming_items():
    print("get_upcoming_items...")
    try:
        options = ChromeOptions()
        user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36"
        options.add_argument('user-agent=' + user_agent)
        #options.add_argument("start-maximized")
        options.add_argument("lang=ko_KR")
        options.add_argument('headless')
        options.add_argument('window-size=1920x1080')
        options.add_argument("disable-gpu")
        options.add_argument("--no-sandbox")
        options.add_argument("disable-dev-shm-usage")
        
        # chrome driver
        driver = webdriver.Chrome('chromedriver', options=options)

        # 접속 대기
        driver.implicitly_wait(1)

        # 나이키 접속
        driver.get('https://www.nike.com/kr/launch?s=upcoming')

        # 이미지를 불러오기 위해 스크롤 내려갔다가 올라옴
        for _ in range(0, 10):
            driver.find_element(By.TAG_NAME, "body").send_keys(Keys.PAGE_DOWN)
            time.sleep(1)

        for _ in range(0, 10):
            driver.find_element(By.TAG_NAME, "body").send_keys(Keys.PAGE_UP)
            time.sleep(1)

        # 1초 대기
        time.sleep(1)

        # 페이지 소스
        html = driver.page_source

        soup = BeautifulSoup(html, 'html.parser')

        #print(soup.prettify())

        upcoming_items =  soup.find_all('div', class_='product-card')
        print(len(upcoming_items), "개의 아이템을 찾았습니다.")

        return upcoming_items

    except Exception as e:
        print(e)
        driver.quit()

    finally:
        print("finally...")
        driver.quit()
