@echo OFF

TITLE Moodle Reset

echo Server must be running...
tasklist | findstr http
if errorlevel 1 goto :exit

tasklist | findstr mysql
if errorlevel 1 goto :exit

echo Server is running!

echo Kill all sessions...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\kill_all_sessions.php

echo Enable maintenance mode...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --enable

echo Move config.php file...
MOVE C:\moodle-local\server\moodle\config.php C:\moodle-local\server\moodle\config-bkp.php

MOVE C:\moodle-local\server\moodledata\lang C:\moodle-local\server\moodledata-bkp\lang

echo Drop moodle database...
C:\moodle-local\server\mysql\bin\mysqladmin.exe -f -u root drop moodle

echo Clear Moodledata and keep lang folder...
mkdir C:\moodle-local\server\moodledata-bkp
MOVE C:\moodle-local\server\moodledata\lang C:\moodle-local\server\moodledata-bkp\lang
rmdir /s /q C:\moodle-local\server\moodledata
mkdir C:\moodle-local\server\moodledata
MOVE C:\moodle-local\server\moodledata-bkp\lang C:\moodle-local\server\moodledata\lang
rmdir /s /q C:\moodle-local\server\moodledata-bkp

echo Install Moodle...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\install.php --dbtype=mariadb --wwwroot="https://moodle.local"  --fullname="Moodle Local" --shortname="Moodle Local" --adminpass=fSt@8nNV --adminemail=admin@moodle.local --non-interactive --agree-license

echo Disable maintenance mode...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --disable

echo Build theme cache...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\build_theme_css.php --themes=boost
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\build_theme_css.php --themes=classic

echo Set configurations...
:: C:\moodle-local\server\php\php.exe server\moodle\admin\cli\cfg.php --name=theme --set=classic

:: C:\moodle-local\server\php\php.exe server\moodle\admin\cli\cfg.php --name=allowuserthemes --set=1
:: C:\moodle-local\server\php\php.exe server\moodle\admin\cli\cfg.php --name=allowcoursethemes --set=1
:: C:\moodle-local\server\php\php.exe server\moodle\admin\cli\cfg.php --name=allowcategorythemes --set=1
:: C:\moodle-local\server\php\php.exe server\moodle\admin\cli\cfg.php --name=allowcohortthemes --set=1
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\cfg.php --name=allowthemechangeonurl --set=1

pause
echo SUCCESS!
goto :end

:exit

echo Reset ERROR!
pause
:end

