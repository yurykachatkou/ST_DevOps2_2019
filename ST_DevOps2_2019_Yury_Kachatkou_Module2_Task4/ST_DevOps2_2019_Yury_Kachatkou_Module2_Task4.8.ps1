#8.	Создать файл-сценарий вывода списка установленных программных продуктов в виде таблицы с полями Имя и Версия.
Get-WmiObject Win32_InstalledWin32Program | Format-Table -Property Name, Version