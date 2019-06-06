#1.1.	Сохранить в текстовый файл на диске список запущенных(!) служб. Просмотреть содержимое диска. Вывести содержимое файла в консоль PS.
Param(
[string]$ServPath="C:\RunServ.txt",
[string]$ProcStat="Running",
[string]$DiskPath="D:\various"
)

Get-Service | Where-Object{$_.Status -eq $ProcStat} | Out-File $ServPath
Get-ChildItem $DiskPath
Get-Content $ServPath
