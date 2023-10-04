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
ExecStart=/usr/bin/python3 /home/christoph.imler/BouvetKantine/main.py
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



## Postgress:
sudo apt install wget ca-certificates

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

sudo apt update

apt install postgresql postgresql-contrib

sudo -u postgres psql

# Timescaledb: https://docs.timescale.com/self-hosted/latest/install/installation-linux/
apt install gnupg postgresql-common apt-transport-https lsb-release wget

/usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

echo "deb https://packagecloud.io/timescale/timescaledb/ubuntu/ $(lsb_release -c -s) main" | sudo tee /etc/apt/sources.list.d/timescaledb.list

wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey | sudo apt-key add -

apt update

apt install timescaledb-2-postgresql-14


apt-get install postgresql-client

systemctl restart postgresql

sudo -u postgres psql