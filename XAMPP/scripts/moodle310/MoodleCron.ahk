#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir C:\moodle-local\server  ; Ensures a consistent starting directory.


Loop
{
RunWait, php\php.exe moodle\admin\cli\cron.php , ,Hide ; Runs Moodle cron in hide mode
Sleep 60*1000 ; Sleep for 600*1 seconds
}