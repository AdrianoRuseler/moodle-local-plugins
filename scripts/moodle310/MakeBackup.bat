@echo OFF
TITLE Moodle Backup

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


echo Server must be running...
tasklist | findstr http
if errorlevel 1 goto :exit

tasklist | findstr mysql
if errorlevel 1 goto :exit

echo Server is running!!

ECHO Create Backup Directory
mkdir %BKPDIR%

echo Kill all sessions...
%PHP% %ADMCLI%\kill_all_sessions.php

echo Enable maintenance mode...
%TOOLS%\wget.exe -O climaintenance.html https://raw.githubusercontent.com/AdrianoRuseler/moodle-local-plugins/main/climaintenance.html
MOVE climaintenance.html %SVRDIR%\moodledata\

echo Purge Moodle cache...
%PHP% %ADMCLI%\purge_caches.php

echo Fix courses...
%PHP% %ADMCLI%\cli\fix_course_sequence.php -c=* --fix

echo Zip folders...
cd %BKPDIR%
%ZIP% a -t7z moodledata.7z %SVRDIR%\moodledata\
%ZIP% a -t7z moodlecore.7z %SVRDIR%\moodle\

echo Dump database...
%SVRDIR%\mysql\bin\mysqldump.exe -u root -C -Q -e --create-options moodle > mdldbdump.sql
%ZIP% a -t7z mdldbdump.sql.7z mdldbdump.sql
DEL mdldbdump.sql

:: CP C:\moodle38-local\server\moodle\config.php config.php

echo Disable maintenance mode...
%PHP% %ADMCLI%\maintenance.php --disable

pause

goto :end

:exit

echo BACKUP ERROR!
pause
:end
