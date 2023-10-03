import requests
import pandas as pd
import re
from typing import List, Tuple

SOUP_STRINGS = ['suppe']
DINNER_STRINGS = ['varmrett','hovedrett','varmmat']

def process_dish(dish: str, keywords: list) -> str:
    for keyword in keywords:
        dish = dish.replace(keyword, "", 1)
    return dish

def get_types(dishes:list) -> Tuple[str, str]:
    hot_food, soup = dishes[0].lower(), dishes[1].lower()
    for keyword in DINNER_STRINGS:
        if hot_food.startswith(keyword):
            hot_food = process_dish(hot_food, DINNER_STRINGS)
            soup = process_dish(soup, SOUP_STRINGS)
            return hot_food, soup
    for keyword in SOUP_STRINGS:
        if hot_food.startswith(keyword):
            hot_food, soup = soup, hot_food  # swap the values
            hot_food = process_dish(hot_food, DINNER_STRINGS)
            soup = process_dish(soup, SOUP_STRINGS)
            return hot_food, soup
    # default
    return hot_food, soup
    
def clean(texts: List[str]) -> List[str]:
    cleaned_texts = []
    for text in texts:
        cleaned_text = re.sub(r'dagens|:', '', text, flags=re.IGNORECASE)
        cleaned_texts.append(cleaned_text.strip())
    return cleaned_texts

    
def fetch_data(url: str) -> dict:
    try:
        response = requests.get(url)
        response.raise_for_status()  # This will raise a HTTPError if the request failed
    except requests.exceptions.RequestException as e:
        print(f'An error occurred: {e}')
        return {}
    else:
        return response.json()

def process_data(data: dict) -> pd.DataFrame:
    week = data['weekNumber']
    all_dishes = []

    for i in data['days']:
        dayOfWeek = i['day']
        ds = i['dishes']
        ds = clean(ds)
        hot_food, soup = get_types(ds)  # Note: function name changed to snake_case
        all_dishes.append([week, dayOfWeek, hot_food, soup])

    return pd.DataFrame(all_dishes, columns=['WeekNumber', 'DayOfWeek', 'MainCourse', 'Soup'])


def main():
    URL = 'https://i74qu6dp3m.execute-api.us-east-2.amazonaws.com/'
    data = fetch_data(URL)
    if data:
        df = process_data(data)
        # Do something with the data. Add a connection string or something like that. probably pyodbc?
        print(df)


if __name__ == "__main__":
    main()

