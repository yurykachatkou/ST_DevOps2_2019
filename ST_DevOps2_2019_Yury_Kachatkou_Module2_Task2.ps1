#1.	Просмотреть содержимое ветви реeстра HKCU
Get-ChildItem HKCU:\
#2.	Создать, переименовать, удалить каталог на локальном диске
New-Item -ItemType directory -Path C:\Kochetkov
Rename-Item -Path C:\Kochetkov -NewName YuryKochetkov
Remove-Item -Path C:\YuryKochetkov
#3.	Создать папку C:\M2T2_ФАМИЛИЯ. Создать диск ассоциированный с папкой 
#C:\M2T2_ФАМИЛИЯ
New-Item -ItemType directory -Path C:\M2T2_Kachatkou
New-PSDrive -Name Kachatkou –PSProvider FileSystem -Root "C:\M2T2_Kachatkou"
#4.	Сохранить в текстовый файл на созданном диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
$ProcPath="C:\RunServ.txt"
Get-Service | Where{$_.Status -eq "Running"} | Out-File $ProcPath
Get-Content $ProcPath
#5.	Просуммировать все числовые значения переменных текущего сеанса.
$sum1=0
foreach($num1 in Get-Variable)
{
    if($num1.Value -is [int] -or $num1.Value -is [double] -or $num1.Value -is [float] -or $num1.Value -is [decimal] -and $num1.Name -ne "sum1")
    {
    $sum1+=$num1.Value
    }

}
Write-Output $sum1
#6.	Вывести список из 6 процессов занимающих дольше всего процессор.
Get-Process | Sort-Object CPU -Descending | Select-Object -First 6
#7.	Вывести список названий и занятую виртуальную память (в Mb) каждого процесса, разделённые знаком тире, при этом если процесс занимает более 100Mb – выводить информацию красным цветом, иначе зелёным.
Get-Process | ForEach-Object{
    if($_.VM/1MB -gt 100)
    {
    write-host $_.Name  " -- " ($_.VM/1MB)"MB" -ForegroundColor "Red"
    }
    else{write-host $_.Name " -- " ($_.VM/1MB)"MB" -ForegroundColor "Green"}
}
#8.	Подсчитать размер занимаемый файлами в папке C:\windows (и во всех подпапках) за исключением файлов *.tmp
Get-ChildItem -Recurse -Exclude "*.tmp" | Measure-Object -Property Length -sum
#9.	Сохранить в CSV-файле информацию о записях одной ветви реестра HKLM:\SOFTWARE\Microsoft.
$RegPath="C:\HKLMBranch.csv"
Get-ChildItem "HKLM:\SOFTWARE\Microsoft" | Export-Csv $RegPath
#10 Сохранить в XML -файле историческую информацию о командах выполнявшихся в текущем сеансе работы PS.
$HistPath="C:\GetHist.xml"
Get-History | Export-Clixml $HistPath
#11.	Загрузить данные из полученного в п.10 xml-файла и вывести в виде списка информацию о каждой записи, в виде 5 любых (выбранных Вами) свойств.
Import-Clixml $HistPath | Select-Object Id, CommandLine, ExecutionStatus, StartExecutionTime, EndExecutionTime
#12	Удалить созданный диск и папку С:\M2T2_ФАМИЛИЯ
Remove-PSDrive -Name Kachatkou
Remove-Item -Path C:\M2T2_Kachatkou