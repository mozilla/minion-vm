#!/usr/bin/env bash

MINION_BASE_DIRECTORY=/opt/minion

# Install frontend only packages on Vagrant systems
if [[ `id -un vagrant` == 'vagrant' ]]; then
  apt-get install -y libldap2-dev \
    libsasl2-dev
fi

# First, source the virtualenv
cd ${MINION_BASE_DIRECTORY}
source minion-env/bin/activate

# Install minion-frontend
# git clone https://github.com/marumari/minion-frontend.git ${MINION_FRONTEND}
cd ${MINION_BASE_DIRECTORY}/minion-frontend
python setup.py develop

# Configure minion-frontend
mkdir -p /etc/minion
mv /tmp/frontend.json /etc/minion

# Add the minion init scripts to the system startup scripts
cp ${MINION_BASE_DIRECTORY}/minion-frontend/scripts/minion-init /etc/init.d/minion
chown root:root /etc/init.d/minion
chmod 755 /etc/init.d/minion
update-rc.d minion defaults 40

# Setup the minion environment for the minion user
echo -e "\n# Minion convenience commands" >> ~minion/.bashrc
echo -e "alias miniond=\"supervisord -c ${MINION_BASE_DIRECTORY}/minion-frontend/etc/supervisord.conf\"" >> ~minion/.bashrc
echo -e "alias minionctl=\"supervisorctl -c ${MINION_BASE_DIRECTORY}/minion-frontend/etc/supervisord.conf\"" >> ~minion/.bashrc

# Start Minion
service minion start
sleep 5

# Start up minion-frontend; in Docker, this is the CMD
if [[ $MINION_DOCKERIZED == 'true' ]]; then
  tail -f /var/log/minion/*.log
fi
