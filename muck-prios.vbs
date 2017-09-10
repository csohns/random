Dim WinScriptHost
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\Windows\system32\muck-prios.bat" & Chr(34), 0, true
Set WinScriptHost = Nothing