#1.1.	Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
Param(
[string]$ServPath="C:\RunServ.txt",
[string]$ProcStat="Running",
[string]$DiskPath="D:\various"
)

Get-Service | Where-Object{$_.Status -eq $ProcStat} | Out-File $ServPath
Get-ChildItem $DiskPath
Get-Content $ServPath
#1.2.	Просуммировать все числовые значения переменных среды Windows. (Параметры не нужны)

$sum1=0
foreach($num1 in Get-ChildItem Env:)
{
    if($num1.Value -as [int] -is [int])
    {
        $sum1+=[int]$num1.Value 
    }

  
}
write-output $sum1
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
#1.4.	Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)
Param
(
    [string]$PathWin="C:\Windows",
    [string]$Ext1="*.tmp",
    [string]$Prop1="Length"

)
Get-ChildItem -Recurse -Path $PathWin -Exclude $Ext1 | Measure-Object -Property $Prop1 -Sum
#1.5.	Создать один скрипт, объединив 3 задачи:

Param
(
    $CsvPath1="C:\SecUpd.csv",
    $SecPar1="*secur*",
    $RegPath1="HKLM:\SOFTWARE\Microsoft",
    $XmlPath1="C:\RegInf.xml"

)
#1.5.1.	Сохранить в CSV-файле информацию обо всех обновлениях безопасности ОС.
Get-HotFix -Description $SecPar1 | Export-Csv $CsvPath1
#1.5.2.	Сохранить в XML-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
Get-ChildItem $RegPath1 | Export-Clixml $XmlPath1
#1.5.3.	Загрузить данные из полученного в п.1.5.1 или п.1.5.2 файла и вывести в виде списка  разным разными цветами
Import-Csv $CsvPath1  | ForEach-Object `
{
    if($_.HotFixID -like "KB448*")
    {
        Write-Host $_.CSName, $_.InstalledOn, $_.HotFixID -Separator " -- " -ForegroundColor Green
    }
    else
    {
        Write-Host $_.CSName, $_.InstalledOn, $_.HotFixID -Separator " -- " -ForegroundColor Red
    }
}
#2.	Работа с профилем
#2.1.	Создать профиль
New-Item -ItemType file -Path $profile -force
#2.2.	В профиле изненить цвета в консоли PowerShell
notepad $profile

$host.PrivateData.ConsolePaneBackgroundColor = "Black"
$host.PrivateData.ConsolePaneForegroundColor = "White"
$host.PrivateData.ConsolePaneTextBackgroundColor="Green"

#2.3.	Создать несколько собственный алиасов
Set-Alias wo Where-Object
Set-Alias mo Measure-Object
Set-Alias proc Get-Process
#2.4.	Создать несколько констант
Set-Variable -Name "processes" -Value (Get-Process) -Option constant
Set-Variable -Name "services" -Value (Get-Service) -Option constant
#2.5.	Изменить текущую папку
Set-Location C:\2019
#2.6.	Вывести приветсвие
Write-Host "Hello, Yury Kachatkou"
#2.7.	Проверить применение профиля

#3.	Получить список всех доступных модулей
Get-Module -ListAvailable