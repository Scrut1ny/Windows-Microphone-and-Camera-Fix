@echo off
@setlocal EnableDelayedExpansion

fltmc >nul 2>&1 || (
    echo(&echo   [33m# Administrator privileges are required.&echo([0m
    PowerShell Start -Verb RunAs '%0' 2> nul || (
        echo   [33m# Right-click on the script and select "Run as administrator".[0m
        >nul pause&exit 1
    )
    exit 0
)

:MENU
cls&echo(&echo   [31m1[0m - [32mAllow[0m Microphone ^& Camera Access
echo   [31m2[0m - [31mDeny[0m Microphone ^& Camera Access
echo   [31m3[0m - Exit&echo(
set /p c=".  [35m#[0m "
if %c%==1 goto :ALLOW
if %c%==2 goto :DENY
if %c%==3 exit /b 1
cls&echo(&echo   [31mChoice "%c%": Invalid option.[0m&>nul timeout /t 2&goto :EXITMENU
exit /b

:ALLOW
>nul 2>&1(
	rem Camera ==============================================================================================================================================
	
	reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects" /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /d "Allow" /t REG_SZ /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera" /d "0x00000001" /t REG_DWORD /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera_ForceAllowTheseApps" /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera_ForceDenyTheseApps" /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera_UserInControlOfTheseApps" /f
	
	rem Microphone ==========================================================================================================================================
	
	reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy Objects" /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture\{3d3130ff-44d6-48f3-8550-e507f5e6fbc6}" /v "DeviceState" /t REG_DWORD /d "0x00000001" /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Capture\{96e569dd-b719-47c1-8595-4c3266433b8a}" /v "DeviceState" /t REG_DWORD /d "0x00000001" /f
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Allow" /f
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /v "Value" /t REG_SZ /d "Allow" /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone" /d "0x00000001" /t REG_DWORD /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone_ForceAllowTheseApps" /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone_ForceDenyTheseApps" /f
	reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone_UserInControlOfTheseApps" /f
	gpupdate /force
)
cls&echo(&echo   All camera ^& microphone access [32mallowed[0m.&>nul timeout /t 5 /nobreak&goto :MENU
exit /b

:DENY
>nul 2>&1(
	rem Camera ==============================================================================================================================================
	
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\webcam" /v "Value" /d "Deny" /t REG_SZ /f
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /t REG_SZ /v "Value" /d "Deny" /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera" /t REG_DWORD /d "0x00000002" /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera_ForceAllowTheseApps" /t REG_MULTI_SZ /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera_ForceDenyTheseApps" /t REG_MULTI_SZ /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessCamera_UserInControlOfTheseApps" /t REG_MULTI_SZ /f
	
	rem Microphone ==========================================================================================================================================
	
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\microphone" /v "Value" /t REG_SZ /d "Deny" /f
	reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /v "Value" /t REG_SZ /d "Deny" /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone" /t REG_DWORD /d "0x00000002" /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone_ForceAllowTheseApps" /t REG_MULTI_SZ /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone_ForceDenyTheseApps" /t REG_MULTI_SZ /f
	reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsAccessMicrophone_UserInControlOfTheseApps" /t REG_MULTI_SZ /f
	gpupdate /force
)
cls&echo(&echo   All camera ^& microphone access [31mdenied[0m.&>nul timeout /t 5 /nobreak&goto :MENU
exit /b 0
