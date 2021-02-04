@echo OFF

TITLE Moodle Restore

SET BKPDIR=C:\moodle38-local\backups\site
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

cd C:\moodle38-local

echo Kill all sessions...
C:\moodle38-local\server\php\php.exe server\moodle\admin\cli\kill_all_sessions.php

echo Enable maintenance mode...
:: C:\moodle38-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --enable
C:\moodle38-local\tools\wget.exe -O climaintenance.html https://raw.githubusercontent.com/AdrianoRuseler/moodle38-plugins/master/climaintenance.html
MOVE climaintenance.html C:\moodle38-local\server\moodledata\

echo Move moodledata...
MOVE C:\moodle38-local\server\moodledata C:\moodle38-local\server\moodledata-bkp

cd %BKPDIR%
C:\moodle38-local\tools\7z\7z.exe x moodledata.7z
MOVE moodledata C:\moodle38-local\server\moodledata

echo Extract mdldbdump.sql.7z...
C:\moodle38-local\tools\7z\7z.exe x mdldbdump.sql.7z

:: echo Drop moodle database...
:: C:\moodle38-local\server\mysql\bin\mysqladmin.exe -f -u root drop moodle

echo Restore mdldbdump.sql...
C:\moodle38-local\server\mysql\bin\mysql.exe -u root moodle < mdldbdump.sql

echo Move moodle folder...
MOVE C:\moodle38-local\server\moodle C:\moodle38-local\server\moodle-bkp

echo Restore Moodle folder...
C:\moodle38-local\tools\7z\7z.exe x moodlecore.7z
MOVE moodle C:\moodle38-local\server\moodle

echo Run moodle cli upgrade...
cd C:\moodle38-local
C:\moodle38-local\server\php\php.exe server\moodle\admin\cli\upgrade.php --non-interactive


cd C:\moodle38-local
echo "Disable maintenance mode..."
C:\moodle38-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --disable

echo Delete tmp files...
rmdir /s /q C:\moodle38-local\server\moodle-bkp
rmdir /s /q C:\moodle38-local\server\moodledata-bkp
DEL C:\moodle38-local\backups\site\mdldbdump.sql

echo Build theme cache...
C:\moodle38-local\server\php\php.exe server\moodle\admin\cli\build_theme_css.php --themes=boost
C:\moodle38-local\server\php\php.exe server\moodle\admin\cli\build_theme_css.php --themes=classic


pause
goto :end

:exit

echo RESTORE ERROR!
pause
:end