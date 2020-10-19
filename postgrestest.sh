#!/bin/bash
#This script will generate dump files on $DIR directory
#The directory names follows the pattern DBNameDATE(ymd)

DATE=`date +%Y%m%d`     # Date

DIR="/home/user/pg_bkp"     #Directory where the dumps will be retained

if [ -d "$DIR" ]; then      #Check if the DIR exists, case it don't a new directory will be created
  echo "The directory exists, initiating dump"
else 
  echo "Dirctory not found"
  echo "Creating directory"
  mkdir /home/user/pg_bkp
fi

while read INSTANCE; do     #Read lines from examples.txt file and create new directories for each DB 
    echo $INSTANCE
    mkdir /home/user/pg_bkp/$INSTANCE$DATE
    pg_dump -Fc $INSTANCE > /home/user/pg_bkp/$INSTANCE$DATE
done < examples.txt

find /home/user/pg_bkp -type d -mtime +10 -delete #Prune dumps older than 10 days
