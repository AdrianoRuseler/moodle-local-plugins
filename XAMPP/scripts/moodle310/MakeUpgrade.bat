@echo OFF

TITLE Moodle Upgrade!

echo Set script variables...
SET BASEDIR=C:\moodle-local
echo BASEDIR folder: %BASEDIR%

SET SVRDIR=%BASEDIR%\server
echo Server folder: %SVRDIR%

SET BKPDIR=%BASEDIR%\backups
echo BKPDIR folder: %BKPDIR%

SET TOOLS=%BASEDIR%\tools
echo Tools folder: %TOOLS%

SET ZIP=%BASEDIR%\tools\7z\7z.exe
echo 7z Location: %ZIP%

SET PHP=%SVRDIR%\php\php.exe 
echo PHP Location: %PHP%

SET ADMCLI=%SVRDIR%\moodle\admin\cli
echo ADMCLI Location: %ADMCLI%

SET MDLCORE=https://download.moodle.org/download.php/direct/stable310/moodle-latest-310.zip
::SET MDLCORE=https://download.moodle.org/download.php/direct/stable310/moodle-3.10.3.zip
echo MDLCORE: %MDLCORE%

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

echo Create tmp folder..
mkdir %BKPDIR%\mdltmp
cd %BKPDIR%\mdltmp

ECHO Get Moodle core files...
%TOOLS%\wget.exe -O moodle-latest-310.zip %MDLCORE%

if not exist moodle-latest-310.zip goto :exit
echo file moodle-latest-310.zip found...

ECHO Extract moodle files...
%ZIP% x moodle-latest-310.zip

if not exist moodle goto :exit
echo folder moodle found...

ECHO Get Moodle-local plugins...
%TOOLS%\wget.exe -O moodle-plugins.7z https://github.com/AdrianoRuseler/moodle-local-plugins/raw/main/XAMPP/moodle.7z

if not exist moodle-plugins.7z goto :exit
echo file moodle-plugins.7z found...
%ZIP% x moodle-plugins.7z

echo Move moodle folder...
MOVE %SVRDIR%\moodle %SVRDIR%\moodle-bkp
MOVE %BKPDIR%\mdltmp\moodle %SVRDIR%\moodle

ECHO Get defaults.php file...
%TOOLS%\wget.exe -O %SVRDIR%\moodle\local\defaults.php https://raw.githubusercontent.com/AdrianoRuseler/moodle-local-plugins/main/XAMPP/moodle/local/defaults.php

echo Restore config.php file...
COPY %SVRDIR%\moodle-bkp\config.php %SVRDIR%\moodle\config.php

echo Run moodle cli upgrade...
%PHP% %ADMCLI%\upgrade.php --non-interactive

echo Disable maintenance mode...
%PHP% %ADMCLI%\maintenance.php --disable

echo Delete tmp files...
rmdir /s /q %SVRDIR%\moodle-bkp
rmdir /s /q %BKPDIR%\mdltmp

echo Build theme cache...
%PHP% %ADMCLI%\build_theme_css.php --themes=boost
%PHP% %ADMCLI%\build_theme_css.php --themes=classic


pause

goto :end

:exit

echo UPGRADE ERROR!
pause
:end

