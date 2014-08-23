#!/usr/bin/bash
########################################################################
# Unwanted Archival Log script !!!
#
# Usage: sh <SciprtName.sh>
#
# Created By: Ramesh Shihora
########################################################################
DB_ARCHIVE="/appl/web/db4826/bin/db_archive"
DB_RECOVER="/appl/web/db4826/bin/db_recover"
BACKUPS="/appl/policy/archive/"
TODAY=`date +%m.%d.%y`
DT=`date +%m.%d.%y.%H.%M.%S`
 
# Start a full backup.
echo "Starting full Archive ..."
echo " "
mkdir -p ${BACKUPS}/${TODAY}/logs
mkdir -p ${BACKUPS}/${TODAY}/active
ACTIVE="${BACKUPS}/${TODAY}/active"
FLAG=0
LOGFILE="${BACKUPS}/${TODAY}/logs/$DT-full-backup-inactive-logfiles"
cd ${BACKUPS}/${TODAY}/logs 
${DB_ARCHIVE} -a | wc -l
 
if [ $? -gt 0 ]
then
        ${DB_ARCHIVE} -a > $LOGFILE 
else
        echo "There is No New log archive generated today `date` ...!!" > $LOGFILE 
        FLAG=1
fi
 
cd $DB_HOME
echo "List of unwanted log files ..."
for logfile in `$DB_ARCHIVE -a`
do
        mv -f ${logfile} ${BACKUPS}/${TODAY}/logs/
done
 
if [ $FLAG -eq 0 ]
then
        if [ -f $LOGFILE ]
        then
                cat $LOGFILE
        fi
else
        echo "Sorry No New Log File Generated ...!!!"
fi
 
 
echo " "
TOTAL=`ls -lrt ${BACKUPS}/${TODAY}/logs/ | wc -l`
#TCOMP=`cat $LOGFILE`
echo "The Unwanted Archive log has been shipped to "${BACKUPS}/${TODAY}/logs" location ..."
 
echo "Starting up the Active backup log file..."
for logfl in `${DB_ARCHIVE} -l`
do
  # For maximum paranoia, we want repository activity *while* we're
  # making the full backup.
  cp ${logfl} ${BACKUPS}/${TODAY}/active/
done
 
#cat ${RECORDS}/${PROJ}-full-backup-inactive-logfiles | xargs rm -f
#cd ../..
echo "Full backup completed)."
