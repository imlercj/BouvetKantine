import json

from datetime import datetime
from postgres_func import Postgres

import paho.mqtt.client as mqtt


from user_secrets import (HOST_ADDRESS,
                        MOSQUITTO_PASSWORD, MOSQUITTO_USERNAME)



# Define MQTT on_connect callback function
def on_connect(client, userdata, flags, rc):
    topic = "smx/device/#"
    print("Connected with result code " + str(rc))
    client.subscribe(topic)

# Define MQTT on_message callback function
def on_message(client, userdata, msg, postgres, watchdog_q):
    payload = json.loads(msg.payload.decode("utf-8"))
    if payload["messageType"] == "single_ts":
        #print("Received message: " + msg.payload.decode("utf-8"))
        sensor_name = payload["sensor_name"]
        direction = payload["direction"]
        time = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        last_5min_sum = payload["last_5min_sum"]
        postgres.insert_data_passings([(time, direction, sensor_name, last_5min_sum)])

    watchdog_q.put("is alive")

def main(q):

    host = HOST_ADDRESS
    username = MOSQUITTO_USERNAME
    password = MOSQUITTO_PASSWORD
    while True:
        try:

            client = mqtt.Client(client_id=host, protocol=mqtt.MQTTv311)

            postgres = Postgres()

            # Set MQTT on_connect and on_message callback functions
            client.on_connect = on_connect
            client.on_message = lambda client, userdata, msg,: on_message(client, userdata, msg, postgres, q)

            # Set MQTT username and password (device key)
            client.username_pw_set(username=username, password=password)

            # Connect to Azure IoT Hub
            client.connect(host, 1883)

            # Start MQTT loop
            client.loop_forever()
        except Exception as e:
            print(e)

if __name__ == '__main__':
    main()
