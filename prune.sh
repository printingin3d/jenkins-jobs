for t in houseelf documents
do
    BACKUP_DIR=/Volume1/public/backup/${t}_backup/

    echo "deleting daily backups"
    # 2. CLEAN UP CODES WITH STRICT RETENTION
    # Keep dailies for 7 days
    find $BACKUP_DIR -name $t"_daily_*gz" -type f -mtime +7 -exec rm {} \;

    echo "deleting weekly backups"
    # Keep weeklies for 28 days (4 weeks)
    find $BACKUP_DIR -name $t"_weekly_*gz" -type f -mtime +28 -exec rm {} \;

    echo "deleting monthly backups"
    # (Optional) Keep monthlies for a year (365 days)
    # If you want to keep monthlies forever, just omit this line entirely
    find $BACKUP_DIR -name $t"*gz" -type f -mtime +365 -exec rm {} \;
done
