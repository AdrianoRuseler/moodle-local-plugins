@echo OFF

TITLE Moodle Reset!

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

SET TSKCLI=%SVRDIR%\moodle\admin\tool\task\cli
echo TSKCLI Location: %TSKCLI%


echo Server must be running...
tasklist | findstr http
if errorlevel 1 goto :exit

tasklist | findstr mysql
if errorlevel 1 goto :exit

echo Server is running!

echo Kill all sessions...
%PHP% %ADMCLI%\kill_all_sessions.php

echo Enable maintenance mode...
%PHP% %ADMCLI%\maintenance.php --enable

echo Move config.php file...
MOVE %SVRDIR%\moodle\config.php %SVRDIR%\moodle\config-bkp.php
MOVE %SVRDIR%\moodledata\lang %SVRDIR%\moodledata-bkp\lang

echo Drop moodle database...
%SVRDIR%\mysql\bin\mysqladmin.exe -f -u root drop moodle

echo Clear Moodledata and keep lang folder...
mkdir %SVRDIR%\moodledata-bkp
MOVE %SVRDIR%\moodledata\lang %SVRDIR%\moodledata-bkp\lang
rmdir /s /q %SVRDIR%\moodledata
mkdir %SVRDIR%\moodledata
MOVE %SVRDIR%\moodledata-bkp\lang %SVRDIR%\moodledata\lang
rmdir /s /q %SVRDIR%\moodledata-bkp

ECHO Get defaults.php file...
%TOOLS%\wget.exe -O %SVRDIR%\moodle\local\defaults.php https://raw.githubusercontent.com/AdrianoRuseler/moodle-local-plugins/main/scripts/moodle310/server/moodle/local/defaults.php

echo Install Moodle...
%PHP% %ADMCLI%\install.php --dbtype=mariadb --wwwroot="https://moodle.local"  --fullname="Moodle Local" --shortname="Moodle 3.10+" --adminpass=K$n9q5Tg --adminemail=admin@moodle.local --non-interactive --agree-license

echo Disable maintenance mode...
%PHP% %ADMCLI%\maintenance.php --disable

:: echo Build theme cache...
:: %PHP% %ADMCLI%\build_theme_css.php --themes=boost
:: %PHP% %ADMCLI%\build_theme_css.php --themes=classic


echo Set configurations...
%PHP% %ADMCLI%\cfg.php --name=theme --set=classic

%PHP% %ADMCLI%\cfg.php --name=allowuserthemes --set=1
%PHP% %ADMCLI%\cfg.php --name=allowcoursethemes --set=1
%PHP% %ADMCLI%\cfg.php --name=allowcategorythemes --set=1
%PHP% %ADMCLI%\cfg.php --name=allowcohortthemes --set=1
%PHP% %ADMCLI%\cfg.php --name=downloadcoursecontentallowed --set=1
%PHP% %ADMCLI%\cfg.php --name=allowthemechangeonurl --set=1
%PHP% %ADMCLI%\cfg.php --name=lang --set=pt_br
%PHP% %ADMCLI%\cfg.php --name=doclang --set=en

echo Run task h5p_get_content_types_task...
%PHP% %TSKCLI%\schedule_task.php --execute="\core\task\h5p_get_content_types_task"

pause
echo SUCCESS!
goto :end

:exit

echo Reset ERROR!
pause
:end

