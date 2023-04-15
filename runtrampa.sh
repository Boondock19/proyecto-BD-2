#!/bin/bash

#Run en consola sh ./Bash.sh
# Corremos el script psql 
sudo -u postgres dropdb -i -e GroceryStoreData-1510627-1210921
sudo -u postgres createdb GroceryStoreData-1510627-1210921
# sudo -u postgres psql -f groceryStore.sql
sudo -u postgres psql -f groceryStore-psql.sql
sudo -u postgres psql -f nombresillos2.sql