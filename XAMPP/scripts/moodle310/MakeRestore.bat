@echo OFF

TITLE Moodle Restore!
echo Set script variables...

SET BASEDIR=C:\moodle-local
echo BASEDIR folder: %BASEDIR%

SET SVRDIR=%BASEDIR%\server
echo Server folder: %SVRDIR%

SET TOOLS=%BASEDIR%\tools
echo Tools folder: %TOOLS%

SET ZIP=%BASEDIR%\tools\7z\7z.exe
echo 7z Location: %ZIP%

SET PHP=%SVRDIR%\php\php.exe 
echo PHP Location: %PHP%

SET ADMCLI=%SVRDIR%\moodle\admin\cli
echo ADMCLI Location: %ADMCLI%

SET BKPDIR=%BASEDIR%\backups\site
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

echo Kill all sessions...
%PHP% %ADMCLI%\kill_all_sessions.php

echo Enable maintenance mode...
:: %PHP% %ADMCLI%\maintenance.php --enable
%TOOLS%\wget.exe -O climaintenance.html https://raw.githubusercontent.com/AdrianoRuseler/moodle-local-plugins/main/climaintenance.html
MOVE climaintenance.html %SVRDIR%\moodledata\

echo Move moodledata...
MOVE %SVRDIR%\moodledata %SVRDIR%\moodledata-bkp

cd %BKPDIR%
%ZIP% x moodledata.7z
MOVE moodledata %SVRDIR%\moodledata

echo Extract mdldbdump.sql.7z...
%ZIP% x mdldbdump.sql.7z

:: echo Drop moodle database...
:: %SVRDIR%\mysql\bin\mysqladmin.exe -f -u root drop moodle

echo Restore mdldbdump.sql...
%SVRDIR%\mysql\bin\mysql.exe -u root moodle < mdldbdump.sql

echo Move moodle folder...
MOVE %SVRDIR%\moodle %SVRDIR%\moodle-bkp

echo Restore Moodle folder...
%ZIP% x moodlecore.7z
MOVE moodle %SVRDIR%\moodle

echo Run moodle cli upgrade...
%PHP% %ADMCLI%\upgrade.php --non-interactive

echo "Disable maintenance mode..."
%PHP% %ADMCLI%\maintenance.php --disable

echo Delete tmp files...
rmdir /s /q %SVRDIR%\moodle-bkp
rmdir /s /q %SVRDIR%\moodledata-bkp
DEL %BKPDIR%\mdldbdump.sql

:: echo Build theme cache...
:: %PHP% %ADMCLI%\build_theme_css.php --themes=boost
:: %PHP% %ADMCLI%\build_theme_css.php --themes=clean


pause
goto :end

:exit

echo RESTORE ERROR!
pause
:end