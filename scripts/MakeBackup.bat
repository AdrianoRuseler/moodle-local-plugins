@echo OFF

TITLE Moodle Backup

echo Server must be running...
tasklist | findstr http
if errorlevel 1 goto :exit

tasklist | findstr mysql
if errorlevel 1 goto :exit

echo Server is running!!

ECHO Create Backup Directory
mkdir backups\site

echo Kill all sessions...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\kill_all_sessions.php

echo Enable maintenance mode...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --enable


echo Purge Moodle cache...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\purge_caches.php

echo Fix courses...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\fix_course_sequence.php -c=* --fix

echo Zip folders...
cd backups\site
C:\moodle-local\tools\7z\7z.exe a -t7z moodledata.7z C:\moodle-local\server\moodledata\
C:\moodle-local\tools\7z\7z.exe a -t7z moodlecore.7z C:\moodle-local\server\moodle\

echo Dump database...
C:\moodle-local\server\mysql\bin\mysqldump.exe -u root -C -Q -e --create-options moodle > mdldbdump.sql
C:\moodle-local\tools\7z\7z.exe a -t7z mdldbdump.sql.7z mdldbdump.sql
DEL mdldbdump.sql

:: CP C:\moodle-local\server\moodle\config.php config.php

cd C:\moodle-local
echo Disable maintenance mode...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --disable

pause

goto :end

:exit

echo BACKUP ERROR!
pause
:end
