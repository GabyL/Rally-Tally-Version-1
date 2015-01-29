#!/bin/bash
# Run this file by typing in
#  $  ./setdb.sh
# Running this file is like typing in the command below in the terminal
echo "Setting DATABASE_URL"
export DATABASE_URL="postgres://USERNAME:PASSWORD@localhost:5432/DATABASENAME"