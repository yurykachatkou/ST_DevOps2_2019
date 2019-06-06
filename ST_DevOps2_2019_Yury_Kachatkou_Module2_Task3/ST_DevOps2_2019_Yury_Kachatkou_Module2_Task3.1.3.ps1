#1.3.	Вывести список из 10 процессов занимающих дольше всего процессор. Результат записывать в файл.
#1.3.1.	Организовать запуск скрипта каждые 10 минут
Param
(
    [string]$ProcPath="C:\ProcFile.txt",
    [parameter(Mandatory=$true,HelpMessage="Enter number of processes to show")]
    [int]$ProcSort=10,
    [string]$SortCol='CPU'


)
Get-Process | Sort-Object $SortCol -Descending | Select-Object -First $ProcSort | Out-File $ProcPath

#1.3.1.	Организовать запуск скрипта каждые 10 минут
$repeat=(New-TimeSpan -Minutes 10)
$ScrPath="d:\code\powershell\ST_DevOps2_2019_Yury_Kachatkou_Module2_Task3\ST_DevOps2_2019_Yury_Kachatkou_Module2_Task3.1.3.ps1"
$opt1 = New-ScheduledJobOption -RunElevated
$cred1=Get-Credential DESKTOP-I2G2MNU\Yury
$trigger1 = New-JobTrigger -Once -RepeatIndefinitely -At (Get-Date) -RepetitionInterval $repeat
Register-ScheduledJob -Name Start -FilePath $ScrPath -Trigger $trigger1 -Credential $cred1 -ScheduledJobOption $opt1