#!/usr/bin/env bash

cat << EOF >> /etc/hosts
192.168.50.49 minion-backend
192.168.50.50 minion-frontend
EOF
