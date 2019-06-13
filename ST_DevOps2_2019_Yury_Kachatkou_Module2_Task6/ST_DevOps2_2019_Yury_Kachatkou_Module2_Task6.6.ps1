
function IpChecker{ #функция для проверки валидности Ip и маски
    param([string]$Ip1, [string]$Ip2,[string]$Mask)   
        
    if($Ip1 -notmatch "^(((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(((\/([4-9]|[12][0-9]|3[0-2]))?)|\s?-\s?((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))))(,\s?|$))+")
    { 
        Write-Output "$Ip1 is incorrect Ip adress. Please enter correct Ip adress"
        break
    }
    elseif ($Ip2 -notmatch "^(((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])(((\/([4-9]|[12][0-9]|3[0-2]))?)|\s?-\s?((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))))(,\s?|$))+") 
    {
        Write-Output "$Ip2 is incorrect Ip adress. Please enter correct Ip adress"
        break  
    }
    elseif ($Mask -notmatch "^(((255\.){3}(255|254|252|248|240|224|192|128|0+))|((255\.){2}(255|254|252|248|240|224|192|128|0+)\.0)|((255\.)(255|254|252|248|240|224|192|128|0+)(\.0+){2})|((255|254|252|248|240|224|192|128|0+)(\.0+){3}))$") 
    {
        Write-Output "$Mask is incorrect network mask or prefix. Please enter correct network mask or Prefix(Range 0-32)"
        break  
    }
    else{return}

}
function PrefToMask{  #функция для перевода префикса в маску
    param([string]$Prefix)
    
    if($Prefix -as [int] -is [int]-and ([int]$Prefix -ge 0 -and [int]$Prefix -le 32))
    {
        $BitMask="1"*$Prefix + "0"*(32-[int]$Prefix) #преобразуем префикс в строку битов размером 32
        $Mask=""
        for($i=0;$i -lt 4;$i++)
        {
            $Mask+=[string]([Convert]::ToInt32($BitMask.Substring($i*8,8), 2)) + "." #конвертируем битовые строки длинной 8 в десятиричный вид
            
        }
          

        $Mask=$Mask.Substring(0,$Mask.Length-1)
        return $Mask
    }
   
    else{return $Prefix}
}


function IpNetComp{

    param([string]$IpA1, [string]$IpA2, [string]$NetMask)
    if(!$IpA1){[string]$IpA1= (Read-Host -Prompt "Enter Ip1 (e.g 192.168.1.1)")}#вводим если не перадано аргументом
    if(!$IpA2){[string]$IpA2 = (Read-Host -Prompt "Enter Ip2 (e.g 192.168.1.2)")}
    if(!$NetMask){[string]$NetMask = (Read-Host -Prompt "Enter Network Mask (e.g 255.255.255.0)or Prefix(range 0-32)")}
         
    $NetMask = PreftoMask -Prefix $NetMask
    IpChecker -Ip1 $IpA1 -Ip2 $IpA2 -Mask $NetMask  #проверяем Ip и маску на валидность
    [string]$Net1=""
    [string]$Net2=""
    $Mask=$NetMask.Split(".")#сплит по точке, создаёт массив из 4х элементов, каждый элемент - октет маски или адреса
    $Ip1=$IpA1.Split(".")
    $Ip2=$IpA2.Split(".")

    for($i=0;$i -lt 4; $i++) #применяем логическое сложение И для каждого октета Ip и Маски
        {
            $Net1+=[string]([int]$Ip1[$i] -band [int]$Mask[$i])+"."#Получаем адреса сети Net1 и Net2 для двух Ip
            $Net2+=[string]([int]$Ip2[$i] -band [int]$Mask[$i])+"."
        }

        $Net1=$Net1.Substring(0,$Net1.Length-1)#убираем последний символ "." в строке
        $Net2=$Net2.Substring(0,$Net2.Length-1)

    if($Net1 -eq $Net2)#сравниваем две строки Ip адресов
        {
            Write-Output "Ip1 $IpA1 and Ip2 $IpA2 belong to the same subnet $Net1"
        }
    else
        {
            Write-Output "Ip1 and Ip2 doesn't belong to the same subnet. Ip1 $IpA1 belongs to the subnet $Net1 Ip2 $IpA2 belongs to the subnet $Net2"
        } 
}
IpNetComp -NetMask 9
