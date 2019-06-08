#1.	Вывести список всех классов WMI на локальном компьютере. 
Get-WmiObject -List
#2.	Получить список всех пространств имён классов WMI. 
Get-WmiObject -class "__Namespace"
#3.	Получить список классов работы с принтером.
Get-WmiObject -List *print*
#4.	Вывести информацию об операционной системе, не менее 10 полей.
Get-WMIObject Win32_OperatingSystem | Format-list -Property *
#5.	Получить информацию о BIOS.
Get-WMIObject Win32_BIOS
#6.	Вывести свободное место на локальных дисках. На каждом и сумму.
$sum = 0
$LogDisk = Get-WmiObject -Class Win32_LogicalDisk
foreach($item in $LogDisk)
{
    $sum += $item.FreeSpace
}
Write-Output $LogDisk | Select-Object DeviceID, FreeSpace
Write-Output $sum
#7.	Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.
$SumResp = 0
$N = 10
for($i = 0; $i -lt $N; $i++)
{
    $Resp = Get-WmiObject -Class Win32_PingStatus -Filter "Address='8.8.8.8'"
    $SumResp += $Resp.ResponseTime
}
Write-Output $SumResp

#8.	Создать файл-сценарий вывода списка установленных программных продуктов в виде таблицы с полями Имя и Версия.
Get-WmiObject Win32_InstalledWin32Program | Format-Table -Property Name, Version
#9.	Выводить сообщение при каждом запуске приложения MS Word.
$Query = "select * from __instancecreationevent within 5 `
where targetinstance isa 'Win32_Process' `
and TargetInstance.Name = 'WINWORD.EXE'"

$Action = {Write-Host "Microsoft Word is running" -ForegroundColor Red}

Register-WmiEvent -Query $Query -Action $Action