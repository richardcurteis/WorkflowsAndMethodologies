@echo off
rem:: https://github.com/netbiosX/Checklists/blob/master/Windows-Privilege-Escalation.md

SET cac=
:: Check if icacls.exe is installed/in PATH
for %%I in (icacls.exe) do (
    if not defined cac (
		:: Set as permissions binary: %cac%
		SET cac=%%~$PATH:I
    )
  )

SET access_chk_path=
:: Check if accesschk.exe is installed/in PATH
for %%A in (accesschk.exe) do (
    if not defined access_chk_path (
		:: Set as permissions binary: %cac%
		SET access_chk_path=%%~$PATH:A
    )
  )

:: If icacls.exe was NOT found, SET cacls.exe
if not defined cac (
      for %%X in (cacls.exe) do (
			SET cac=%%~$PATH:X
		)
    )
	
echo [!] %cac% SET for permissions checks...
echo

echo -- Users Summary --
echo %username% 2>NUL
whoami 2>NUL
echo %userprofile% 2>NUL

echo --- Current Users Privileges ---
whoami /priv

accesschk.exe /accepteula -q -a *

echo --- Anyone Else Logged In? ---
qwinsta

echo --- Groups On System ---
net localgroup

echo --- Any Users in Administrators Group? ---
net localgroup administrators

echo --- Users --- 
net users 

echo -- List User Accounts ---
wmic useraccount list

echo --- List Groups ---
wmic group list

echo --- Sysaccount List ---
wmic sysaccount list

echo --- Identify any local system accounts that are enabled ---
wmic USERACCOUNT WHERE "Disabled=0 AND LocalAccount=1" GET Name

echo --- Rgistry Entries for Autologon ---
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon" 2>nul | findstr "DefaultUserName DefaultDomainName DefaultPassword"

echo -- Password Policy ---
net group

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

echo
echo - Search 'cpassword' Location
echo
Services\Services.xml
ScheduledTasks\ScheduledTasks.xml
Printers\Printers.xml
Drives\Drives.xml
DataSources\DataSources.xml


echo
echo - Possible Passwords - 
echo
findstr /si password *.txt
findstr /si password *.xml
findstr /si password *.ini

echo 
echo - Elevated Credentials Storage? -
echo
C:\> dir /b /s unattend.xml
C:\> dir /b /s web.config
C:\> dir /b /s sysprep.inf
C:\> dir /b /s sysprep.xml
C:\> dir /b /s *pass*
C:\> dir /b /s vnc.ini

echo
echo - McAfee Password? -
echo
type %AllUsersProfile%Application Data\McAfee\Common Framework\SiteList.xml

echo
echo - RealVNC - 
echo
reg query HKEY_LOCAL_MACHINE\SOFTWARE\RealVNC\WinVNC4 /v password

echo
echo - Putty - 
echo
reg query" HKCU\Software\SimonTatham\PuTTY\Sessions"

echo -- Registry --
echo
echo - Creds - 
reg query HKLM /f password /t REG_SZ /s
reg query HKCU /f password /t REG_SZ /s

echo
echo - Windows Autolgin - 
reg query "HKLM\SOFTWARE\Microsoft\Windows NT\Currentversion\Winlogon"

echo 
echo --- Weak Service Permissions ---
echo
echo REF: https://pentestlab.blog/2017/03/30/weak-service-permissions/
echo
