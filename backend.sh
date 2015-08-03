#!/usr/bin/env bash

MINION_ADMINISTRATOR_EMAIL="april@mozilla.com"
MINION_ADMINISTRATOR_NAME="April King"
MINION_BACKEND=/opt/minion/minion-backend

# Only install if we're running on a system with vagrant
if [[ `id -un vagrant` == 'vagrant' ]]; then
  apt-get update && apt-get -y install build-essential \
    curl \
    git \
    libcurl4-openssl-dev \
    libffi-dev \
    mongodb-server \
    nmap \
    postfix \
    python \
    python-dev \
    python-setuptools \
    rabbitmq-server \
    stunnel

  # For some reason, it has trouble adding the rabbitmq groups
  apt-get -y install rabbitmq-server

  # Upgrade setuptools to the newest version
  easy_install --upgrade setuptools
fi

# Install minion-backend
# git clone https://github.com/mozilla/minion-backend.git ${MINION_BACKEND}
cd ${MINION_BACKEND}
python setup.py develop

# Configure minion-backend
mkdir -p /etc/minion
mv /tmp/backend.json /etc/minion

# Install minion-nmap-plugin; comment out git clone if working on minion-nmap-plugin locally
# via Vagrant synced folder
git clone https://github.com/mozilla/minion-nmap-plugin ${MINION_BACKEND}/../minion-nmap-plugin
cd ${MINION_BACKEND}/../minion-nmap-plugin
python setup.py install

# Create database directory for MongoDB and start it up
install -m 700 -o mongodb -g mongodb -d /data/db
mongod --fork --logpath /var/log/mongodb/mongodb.log
sleep 5

# Start RabbitMQ
rabbitmq-server -detached
sleep 5

# Setup minion user account, lock down eggs directory
useradd -m minion
install -m 700 -o minion -g minion -d /run/minion -d /var/lib/minion -d /var/log/minion -d ~minion/.python-eggs

# Start Minion
cd $MINION_BACKEND
su minion -c "scripts/minion-backend-api runserver -a 0.0.0.0 --debug --reload &"
su minion -c "scripts/minion-state-worker &"
su minion -c "scripts/minion-scan-worker &"
su minion -c "scripts/minion-plugin-worker &"
su minion -c "scripts/minion-scanschedule-worker &"
su minion -c "scripts/minion-scanscheduler &"  # requires /run/minion
sleep 5

# Create the initial administrator and database
scripts/minion-db-init "$MINION_ADMINISTRATOR_EMAIL" "$MINION_ADMINISTRATOR_NAME" y

# Eternal process for Docker
if [[ $MINION_DOCKERIZED == "true" ]]; then
  tail -f /var/log/mongodb/mongodb.log /var/log/rabbitmq/*.log
fi
