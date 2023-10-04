from postgres_func import Postgres
import json

from datetime import datetime

passing = json.load(open("example.json", "r"))

postgres = Postgres()

# passing
sensor_name = passing["sensor_name"]
direction = passing["direction"]
time = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
last_5min_sum = passing["last_5min_sum"]
postgres.insert_data_passings([(time, direction, sensor_name, last_5min_sum)])
