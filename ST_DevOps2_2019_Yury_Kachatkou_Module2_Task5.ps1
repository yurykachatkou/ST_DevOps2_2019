#1.	При помощи WMI перезагрузить все виртуальные машины.
$comps=@("WIN-19PRATGDOBI","WIN-2V43LHONPBA", "WIN-OC3FNKN2J6A")
$cred=(get-credential administrator)
(Get-WmiObject Win32_OperatingSystem -ComputerName $comps -Credential $cred).Win32Shutdown(6) 
#2.	При помощи WMI просмотреть список запущенных служб на удаленном компьютере. 
$comps=@("WIN-19PRATGDOBI")
Get-WmiObject Win32_Service -computername "WIN-19PRATGDOBI" | Where-Object{$_.State -eq "Running"}
#3.	Настроить PowerShell Remoting, для управления всеми виртуальными машинами с хостовой.
Enable-PSRemoting 
Set-Item WSMan:\localhost\Client\TrustedHosts -Value 'WIN-19PRATGDOBI, WIN-2V43LHONPBA, WIN-OC3FNKN2J6A'
#4	Для одной из виртуальных машин установить для прослушивания порт 42658. Проверить работоспособность PS Remoting.
winrm set winrm/config/Listener?Address=*+Transport=HTTP '@{Port="42658"}'
Test-WSMan -ComputerName WIN-19PRATGDOBI -Port 42658
#5	Создать конфигурацию сессии с целью ограничения использования всех команд, кроме просмотра содержимого дисков.
#На ВМ
New-PSSessionConfigurationFile -Path DiskUser.pssc -VisibleCmdlets  Get-Help, Exit-PSSession, Get-Command,
Get-ChildItem, Measure-Object, Out-Default, Select-Object, Set-Location, Where-Object, Out-File
$cred = Get-Credential administrator
Register-PSSessionConfiguration -Name DiskUser -Path  .\DiskUser.pssc -RunAsCredential $cred -ShowSecurityDescriptorUI
#На хосте
$cred1 = Get-Credential administrator
$session = New-PSSession -ComputerName "WIN-2V43LHONPBA" -ConfigurationName DiskUser -Credential $cred1
Enter-PSSession $session
