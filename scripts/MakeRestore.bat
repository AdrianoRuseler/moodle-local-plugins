@echo OFF

TITLE Moodle Restore

SET BKPDIR=C:\moodle-local\backups\site
echo Backup folder: %BKPDIR%

echo Looking for files to restore...
if not exist %BKPDIR% goto :exit
echo Folder %BKPDIR% found...
cd %BKPDIR%

if not exist mdldbdump.sql.7z goto :exit
echo file mdldbdump.sql.7z found...

if not exist moodlecore.7z goto :exit
echo file moodlecore.7z found...

if not exist moodledata.7z goto :exit
echo file moodledata.7z found...

echo Server must be running...
tasklist | findstr http
if errorlevel 1 goto :exit

tasklist | findstr mysql
if errorlevel 1 goto :exit

echo Server is running!!

cd C:\moodle-local

echo Kill all sessions...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\kill_all_sessions.php

echo Enable maintenance mode...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --enable

echo Move moodledata...
MOVE C:\moodle-local\server\moodledata C:\moodle-local\server\moodledata-bkp

cd %BKPDIR%
C:\moodle-local\tools\7z\7z.exe x moodledata.7z
MOVE moodledata C:\moodle-local\server\moodledata

echo Extract mdldbdump.sql.7z...
C:\moodle-local\tools\7z\7z.exe x mdldbdump.sql.7z

:: echo Drop moodle database...
:: C:\moodle-local\server\mysql\bin\mysqladmin.exe -f -u root drop moodle

echo Restore mdldbdump.sql...
C:\moodle-local\server\mysql\bin\mysql.exe -u root moodle < mdldbdump.sql

echo Move moodle folder...
MOVE C:\moodle-local\server\moodle C:\moodle-local\server\moodle-bkp

echo Restore Moodle folder...
C:\moodle-local\tools\7z\7z.exe x moodlecore.7z
MOVE moodle C:\moodle-local\server\moodle

echo Run moodle cli upgrade...
cd C:\moodle-local
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\upgrade.php --non-interactive


cd C:\moodle-local
echo "Disable maintenance mode..."
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --disable

echo Delete tmp files...
rmdir /s /q C:\moodle-local\server\moodle-bkp
rmdir /s /q C:\moodle-local\server\moodledata-bkp
DEL C:\moodle-local\backups\site\mdldbdump.sql

pause
goto :end

:exit

echo RESTORE ERROR!
pause
:end