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