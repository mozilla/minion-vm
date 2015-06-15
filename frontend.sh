#!/usr/bin/env bash

MINION_FRONTEND=/opt/minion/minion-frontend

# Only install if we're running on a system with vagrant
if [[ `id -un vagrant` == 'vagrant' ]]; then
  apt-get update && apt-get install -y build-essential \
    curl \
    git \
    libcurl4-openssl-dev \
    python \
    python-dev \
    python-setuptools \
    stunnel
fi

# Install minion-frontend
# git clone https://github.com/marumari/minion-frontend.git ${MINION_FRONTEND}
cd ${MINION_FRONTEND}
python setup.py develop

# Configurure minion-frontend
mkdir -p /etc/minion
mv /tmp/frontend.json /etc/minion

# Start up minion-frontend; in Docker, this is the CMD
if [[ `id -un vagrant` == 'vagrant' ]]; then
  scripts/minion-frontend -a 0.0.0.0 --debug --reload &
fi
