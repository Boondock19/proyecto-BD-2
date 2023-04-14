#!/bin/bash

#Run en consola sh ./Bash.sh
# Corremos el script psql 
sudo -u postgres dropdb -i -e grocery
sudo -u postgres createdb grocery
sudo -u postgres psql -f groceryStore.sql