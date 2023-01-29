#!/bin/bash
set -o pipefail

sudo docker-compose up --build -d --remove-orphans > /dev/null

python3 -m pytest -q -W ignore::DeprecationWarning tests/*

