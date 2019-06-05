$input1= get-content c:\Users\Yury\Desktop\Task.txt
$output1=""
for($i=0;$i -lt $input1.Length;$i++)
{
    if([byte][char]($input1[$i]) -in ([byte][char]'a')..([byte][char]'z')) #проверяем вхождение символа в диапазон от a до z(маленькие буквы)
    {
    
        $temp1=[byte][char]$input1[$i]+2 #сдвиг на 2 символа k-l-m, o-p-q, e-f-g
        $temp1=($temp1-[byte][char]'a')%26 #считаем расстояние от текущего символа до 'a';26 - число букв английского алфавита
        $output1+= [char]($temp1+[byte][char]'a')#организуем циклический сдвиг(z-b;y-a) и конкатенация символов
    }
    elseif([byte][char]($input1[$i]) -in ([byte][char]'A')..([byte][char]'Z'))#проверяем вхождение символа в диапазон от A до Z(большие буквы)
    {
        $temp1=[byte][char]$input1[$i]+2 #те же операции, что и для маленьких букв
        $temp1=($temp1-[byte][char]'A')%26
        $output1+= [char]($temp1+[byte][char]'A')

    }

    else
    {
        $output1+=$input1[$i] #если символ не является буквой, просто прибавляем текущий символ к строке
    }

}
Write-Output $output1
