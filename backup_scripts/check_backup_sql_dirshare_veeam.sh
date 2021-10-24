#! /bin/bash

if find /mnt/backup/sql -mtime 0 &> /dev/null
then
        echo "OK"

else
        curl -s -X POST   https://api.telegram.org/bot******** -d chat_id=********** -d  text="Backup_Error not backup file sql"
fi

if find /mnt/backup/veeam -mtime 0 &> /dev/null
then
        echo "OK"
else
        curl -s -X POST   https://api.telegram.org/bot******** -d chat_id=********** -d text="Backup_Error not backup file veeam"
fi

if find /mnt/backup/Обмен* -mtime 0 &> /dev/null
then
       echo "OK"
else
        curl -s -X POST   https://api.telegram.org/bot******** -d chat_id=********** -d text="Backup_Error not backup file share"
fi

