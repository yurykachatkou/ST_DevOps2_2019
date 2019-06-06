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

#3
Get-Module -ListAvailable