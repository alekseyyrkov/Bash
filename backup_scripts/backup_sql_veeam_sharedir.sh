DATE=`date +"%Y%m%d"`
PATH_SHARE="/mnt/backup"
PATH_BACKUP="/media/share"
PATH_BACKUP_1="/media/backup"

THREEDAYSAGO=`(date --date '3 days ago' --rfc-3339=seconds)`
ONEDAYAGO=`(date --date '1 days ago' --rfc-3339=seconds)`
#Монтируем сетевые шары
sudo mount.cifs \\\\********\\backup /media/share -o credentials=/etc/samba/passwd
sudo mount.cifs \\\\********\\share_folder /media/backup -o credentials=/etc/samba/passwd

if mount | grep /media/share  > /dev/null; then #Проверям примонтированны ли шары

#Поиск последних файлов и копирование их на рейд
        cp -R $PATH_BACKUP_1/Обмен $PATH_SHARE/Обмен-$DATE
        find $PATH_BACKUP/sql -type f -mtime -1 -exec cp -pr "{}" $PATH_SHARE/sql \;
        find $PATH_BACKUP/1c -type f -mtime -1 -exec cp -pr "{}" $PATH_SHARE/1c \;
        find $PATH_BACKUP/veeam -type f -mtime -1 -exec cp -pr "{}" $PATH_SHARE/veeam \;

#       tar --newer-mtime="${ONEDAYAGO}" -czf $PATH_SHARE/sql/sql-$DATE.tar.gz -C $PATH_BACKUP/sql .
#       tar --newer-mtime="${ONEDAYAGO}" -czf $PATH_SHARE/veeam/veeam-$DATE.tar.gz -C $PATH_BACKUP/veeam .

#Поиск старых файлов
        find $PATH_SHARE/1c -mtime +4 -exec rm {} \;
        find $PATH_SHARE/Обмен-* -mtime +4 -exec rm -rf {} \;
        find $PATH_SHARE/sql -mtime +4 -exec rm {} \;
        find $PATH_SHARE/veeam -mtime +4 -exec rm {} \;
#Размонтирование сетевых шар
        sudo umount /media/share
        sudo umount /media/backup
else
        curl -s -X POST  https://api.telegram.org/bot******** -d chat_id=********** -d text="Backup_Error not mount share"
        sudo umount /media/share
        sudo umount /media/backup

fi

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
        curl -s -X POST  https://api.telegram.org/bot******** -d chat_id=********** -d  text="Backup_Error not backup file share"
fi
