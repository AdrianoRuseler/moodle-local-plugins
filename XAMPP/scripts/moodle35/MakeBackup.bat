@echo OFF
echo Set script variables...

SET BASEDIR=C:\moodle35-local
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
%PHP% %ADMCLI%\kill_all_sessions.php

echo Enable maintenance mode...
%TOOLS%\wget.exe -O climaintenance.html https://raw.githubusercontent.com/AdrianoRuseler/moodle38-plugins/master/climaintenance.html
MOVE climaintenance.html %SVRDIR%\moodledata\

:: C:\moodle38-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --enable

echo Purge Moodle cache...
%PHP% %ADMCLI%\purge_caches.php

echo Fix courses...
%PHP% %ADMCLI%\cli\fix_course_sequence.php -c=* --fix

echo Zip folders...
cd backups\site
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
