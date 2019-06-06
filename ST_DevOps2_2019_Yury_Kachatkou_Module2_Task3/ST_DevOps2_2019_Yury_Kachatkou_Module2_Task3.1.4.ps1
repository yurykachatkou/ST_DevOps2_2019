#1.4.	Подсчитать размер занимаемый файлами в папке (например C:\windows) за исключением файлов с заданным расширением(напрмер .tmp)
Param
(
    [string]$PathWin="C:\Windows",
    [string]$Ext1="*.tmp",
    [string]$Prop1="Length"

)
Get-ChildItem -Recurse -Path $PathWin -Exclude $Ext1 | Measure-Object -Property $Prop1 -Sum
