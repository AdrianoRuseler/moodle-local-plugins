#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


; UrlDownloadToFile, https://ufpr.dl.sourceforge.net/project/xampp/XAMPP`%20Windows/7.4.16/xampp-portable-windows-x64-7.4.16-0-VC15.7z , %A_ScriptDir%\xampp.7z

UrlDownloadToFile, https://sourceforge.net/projects/xampp/files/XAMPP`%20Windows/7.4.16/xampp-portable-windows-x64-7.4.16-0-VC15.7z/download , %A_ScriptDir%\xampp.7z

runwait, "C:\Program Files\7-Zip\7z.exe" x "%A_ScriptDir%\xampp.7z" -o"%A_ScriptDir%" -y,, 

FileMoveDir, %A_ScriptDir%\xampp, %A_ScriptDir%\server, R
UrlDownloadToFile, https://raw.githubusercontent.com/AdrianoRuseler/Moodle4Windows/master/server/cleanupxampp.bat , %A_ScriptDir%\server\cleanupxampp.bat

SetWorkingDir %A_ScriptDir%\server
runwait, %A_ScriptDir%\server\cleanupxampp.bat

UrlDownloadToFile, https://github.com/AdrianoRuseler/moodle-local-plugins/raw/main/XAMPP/server-files.7z, %A_ScriptDir%\server-files.7z

runwait, "C:\Program Files\7-Zip\7z.exe" x "%A_ScriptDir%\server-files.7z" -o"%A_ScriptDir%" -y,, 

FileMoveDir, %A_ScriptDir%\server-files, %A_ScriptDir%\moodle-local, R


FileCopyDir, %A_ScriptDir%\server, %A_ScriptDir%\moodle-local\server , 1

SetWorkingDir %A_ScriptDir%\moodle-local\server
runwait, %A_ScriptDir%\moodle-local\server\getpython.bat


; UrlDownloadToFile, https://raw.githubusercontent.com/AdrianoRuseler/Moodle4Windows/master/server/getmoodle.bat , %A_ScriptDir%\moodle-local\server\getmoodle.bat

runwait, %A_ScriptDir%\moodle-local\server\getmoodle.bat


FileDelete, %A_ScriptDir%\server-files.7z
FileDelete, %A_ScriptDir%\xampp.7z

FileRemoveDir, %A_ScriptDir%\server, 1