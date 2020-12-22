#!/bin/bash
#This script will generate dump files on $DIR directory
#The directory names follows the pattern DBNameDATE(ymd)

DATE=`date +%Y%m%d`     # Date

DIR="/s3/bkp"     #Directory where the dumps will be retained

if [ -d "$DIR" ]; then      #Check if the DIR exists, case it don't a new directory will be created
  echo "The directory exists, initiating dump"
else 
  echo "Directory not found"
  echo "Creating directory"
  mkdir /s3/bkp
  s3cmd sync /s3/bkp s3://bucket/  
fi

s3cmd sync /s3/ s3://bucket/

while read INSTANCE; do     # Read lines from examples.txt file and create new directories for each DB 
    echo $INSTANCE
    mysqldump --routines -uuser -ppassword $INSTANCE > /s3/bkp/dump$INSTANCE.sql
    tar -czvf dump$INSTANCE$DATE.tar.gz /s3/bkp/dump$INSTANCE.sql
    rm /s3/bkp/dump$INSTANCE.sql

    #s3cmd put /s3/pg_bkp//s3/pg_bkp/$INSTANCE$DATE/dump$INSTANCE.sql s3://bucket # copy or sync?
done < examples.txt

find /s3/bkp -type f -mtime +10 -delete # Prune dumps older than 10 days
