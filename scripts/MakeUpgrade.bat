@echo OFF

TITLE Moodle Upgrade

echo Kill all sessions...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\kill_all_sessions.php

echo Enable maintenance mode...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --enable

echo Create tmp folder..
mkdir backups\mdltmp
cd C:\moodle-local\backups\mdltmp

ECHO Get Moodle core files...
C:\moodle-local\tools\wget.exe -O moodle-latest-310.zip https://download.moodle.org/download.php/direct/stable310/moodle-latest-310.zip

ECHO Extract moodle files...
C:\moodle-local\tools\7z\7z.exe x moodle-latest-310.zip

ECHO Get Moodle-local plugins...
C:\moodle-local\tools\wget.exe -O moodle-pligins.7z https://github.com/AdrianoRuseler/moodle-local-plugins/raw/main/moodle.7z
C:\moodle-local\tools\7z\7z.exe x moodle-pligins.7z


echo Move moodle folder...
MOVE C:\moodle-local\server\moodle C:\moodle-local\server\moodle-bkp
MOVE C:\moodle-local\backups\mdltmp\moodle C:\moodle-local\server\moodle

echo Restore config.php file...
CP C:\moodle-local\server\moodle-bkp\config.php C:\moodle-local\server\moodle\config.php

echo Run moodle cli upgrade...
cd C:\moodle-local
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\upgrade.php --non-interactive

echo Disable maintenance mode...
C:\moodle-local\server\php\php.exe server\moodle\admin\cli\maintenance.php --disable

echo Delete tmp files...
rmdir /s /q C:\moodle-local\server\moodle-bkp
rmdir /s /q C:\moodle-local\backups\mdltmp

pause