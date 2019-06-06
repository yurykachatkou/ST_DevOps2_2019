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
