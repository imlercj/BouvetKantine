from foodApi import menu
from postgres_func import Postgres
from datetime import date


def pars_df(df):
    """
    entries.append([row.date.strftime('%Y-%m-%d'), 
                row.MainCourse, 
                row.Soup, 
                str(row.WeekNumber), 
                row.DayOfWeek, 
                row.MainCourse, 
                row.Soup, 
                row.date.strftime('%Y-%m-%d'), 
                date.today().strftime('%Y-%m-%d')])
    """                                     
    entries = []
    for row in df.itertuples():
        # [date, maincourse, soup, weeknumber, dayofweek, maincourse, soup, date, updatedat]

        entries.append([str(row.WeekNumber), 
                        row.DayOfWeek, 
                        str(row.MainCourse).lstrip(), 
                        str(row.Soup).lstrip(),
                        row.date.strftime('%Y-%m-%d'), 
                        date.today().strftime('%Y-%m-%d'), 
                        row.date.strftime('%Y-%m-%d'),
                        str(row.MainCourse).lstrip(),
                        str(row.Soup).lstrip()
                        ])
    return entries

menu_df = menu()
postgres = Postgres()

postgres_data = pars_df(menu_df)
postgres.insert_data_menu(postgres_data)