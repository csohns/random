@echo off
sleep 10
wmic process where name="CrashPlanService.exe" CALL setpriority "below normal"
sleep 2
wmic process where name="googledrivesync.exe" CALL setpriority "below normal"
