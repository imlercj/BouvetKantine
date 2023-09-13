from postgres_func import Postgres
import json

from datetime import datetime

passing = json.load(open("example.json", "r"))

data_5_min = json.load(open("example_5min.json", "r"))

postgres = Postgres()

# passing
sensor_name = passing["sensor_name"]
direction = passing["direction"]
time = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
last_5min_sum = passing["last_5min_sum"]
postgres.insert_data_passings([(time, direction, sensor_name, last_5min_sum)])

# 5 min
sensor_name = data_5_min["sensor_name"]
time = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
direction = data_5_min["direction"]
visits = data_5_min["visits"]
postgres.insert_data_passings_5min([(time, direction, sensor_name, visits)])

