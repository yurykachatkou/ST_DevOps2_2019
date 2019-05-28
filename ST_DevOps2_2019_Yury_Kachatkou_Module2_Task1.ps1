#1.	Получите справку о командлете справки
Get-Help Get-Help
# 2. Пункт 1, но детальную справку, затем только примеры
Get-Help Get-Help -Detailed
Get-Help Get-Help -Examples
#3. Получите справку о новых возможностях в PowerShell 4.0 (или выше)
Get-Help about_Windows_PowerShell_5.0
#4. Получите все командлеты установки значений
Get-Command -Verb Set
#5. Получить список команд работы с файлами
Get-Command -Noun *file*
#6.	Получить список команд работы с объектами
Get-Command -Noun *object*
#7.	Получите список всех псевдонимов
Get-Alias
#8.	Создайте свой псевдоним для любого командлета
Set-Alias -Name gpr -Value Get-Process
#9.	Просмотреть список методов и свойств объекта типа процесс
Get-Member -InputObject Process
#10. Просмотреть список методов и свойств объекта типа строка
Get-Member -InputObject String
#11. Получить список запущенных процессов, данные об определённом процессе
Get-Process
Get-Process -Name chrome
#12.Получить список всех сервисов, данные об определённом сервисе
Get-Service
Get-Service -Name Dnscache
#13. Получить список обновлений системы
Get-WindowsUpdateLog
#14. Узнайте, какой язык установлен для UI Windows
Get-UICulture
#15. Получите текущее время и дату
Get-Date
#16. Сгенерируйте случайное число (любым способом)
Get-Random
#17. Выведите дату и время, когда был запущен процесс «explorer». Получите какой это день недели. 
(Get-Process -Name explorer).StartTime
#18. Откройте любой документ в MS Word (не важно как) и закройте его с помощью PowerShell
Stop-Process -Name WINWORD #или -Id номер Id, для конккретного процесса
#19.	Подсчитать значение выражения S=sum(3*i) . N – изменяемый параметр. Каждый шаг выводить в виде строки. (Пример: На шаге 2 сумма S равна 9)
$sum1=0
$N=10
for($i=0;$i -le $N;$i++ )
    {
        $sum1+=3*$i
        write-host $sum1
    }
#20.	Напишите функцию для предыдущего задания. Запустите её на выполнение.
function Sum3x([int]$N)
{
    $sum1=0
    for($i=0;$i -le $N;$i++ )
        {
            $sum1+=3*$i
            write-host $sum1
        }
    $sum1

}
$sum1=Sum3x(15)