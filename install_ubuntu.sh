#!/bin/bash

# Install Mosquitto
sudo apt-get update
sudo apt-get install -y mosquitto mosquitto-clients
sudo apt install software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install python3.8
sudo apt install python3-pip

# Create password file
sudo touch /etc/mosquitto/passwd
#sudo chown mosquitto:mosquitto /etc/mosquitto/passwd
#sudo chmod 0600 /etc/mosquitto/passwd

# Create user accounts
sudo mosquitto_passwd -c /etc/mosquitto/passwd mqtt_login
# password: 1234
# password: #TromsøLegevaktMQTT

# Configure Mosquitto - Må sjekke dette etterpå
#sudo sh -c 'echo "per_listener_settings true" >> /etc/mosquitto/mosquitto.conf'
sudo sh -c 'echo "password_file /etc/mosquitto/passwd" >> /etc/mosquitto/mosquitto.conf'
sudo sh -c 'echo "listener 1883" >> /etc/mosquitto/mosquitto.conf'

# Setup python
git clone https://github.com/imlercj/TromsoLegevakt.git
pip install -r requierments.txt
chmod +x /home/azureuser/TromsoLegevakt/startup_script.sh 


sudo sh -c "cat > /etc/mosquitto/conf.d/default.conf" << 'EOL'
# Place your local configuration in /etc/mosquitto/conf.d/
#
# A full description of the configuration file is at
# /usr/share/doc/mosquitto/examples/mosquitto.conf.example

#per_listener_settings true
password_file /etc/mosquitto/passwd
listener 1883

EOL

# Restart Mosquitto
sudo systemctl restart mosquitto.service

## set up python demon
sudo nano /etc/systemd/system/python_mqtt.service

## insert the following 
[Unit]
Description=Get data from Mosquitto and stores it in azure

[Service]
ExecStart=/usr/bin/python3 /home/azureuser/TromsoLegevakt/main.py
Restart=always
User=azureuser

[Install]
WantedBy=multi-user.target
#### end of insert

sudo systemctl daemon-reload

sudo systemctl start python_mqtt

sudo systemctl restart python_mqtt

sudo systemctl status python_mqtt

nano user_secrets.py
## insert secrets   --

sudo systemctl enable python_mqtt