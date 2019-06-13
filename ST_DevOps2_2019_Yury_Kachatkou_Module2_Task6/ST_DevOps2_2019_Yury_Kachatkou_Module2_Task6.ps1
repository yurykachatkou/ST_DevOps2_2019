#1.	Для каждого пункта написать и выполнить соответсвующий скрипт автоматизации администрирования
#1.1.	Вывести все IP адреса вашего компьютера (всех сетевых интерфейсов)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=TRUE -ComputerName . | Select-Object -Property IPAddress
#1.2.	Получить mac-адреса всех сетевых устройств вашего компьютера и удалённо.
$comps=("WIN-19PRATGDOBI","WIN-2V43LHONPBA", "WIN-OC3FNKN2J6A")
Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Select-Object PSComputerName, description, macaddress
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -ComputerName $comps -Credential(Get-Credential administrator) | Select-Object PSComputerName, description, macaddress
#1.3.	На всех виртуальных компьютерах настроить (удалённо) получение адресов с DHСP.
$comps=("WIN-19PRATGDOBI","WIN-2V43LHONPBA", "WIN-OC3FNKN2J6A")
$cred=(Get-Credential administrator)
Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter IPEnabled=true -ComputerName $comps -Credential $cred | ForEach-Object -Process {$_.InvokeMethod("EnableDHCP", $null)}
#1.4.	Расшарить папку на компьютере
(Get-WmiObject -List -ComputerName . | Where-Object -FilterScript `
{$_.Name –eq "Win32_Share"}).InvokeMethod("Create",("C:\Kachatkou","MyShare",0,25,"Kachatkou folder share"))
#1.5.	Удалить шару из п.1.4
(Get-WmiObject -Class Win32_Share -ComputerName . -Filter "Name='MyShare'").InvokeMethod("Delete",$null)
#1.6.	Скрипт входными параметрами которого являются Маска подсети и два ip-адреса. Результат  – сообщение (ответ) в одной ли подсети эти адреса.
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

function IpNetComp{   #функция для проверки двух Ip адресов. Проверяет находятся ли Ip в одной подсети. Также выводит адреса подсетей.

    param([string]$IpA1, [string]$IpA2, [string]$NetMask)
    if(!$IpA1){[string]$IpA1= (Read-Host -Prompt "Enter Ip1 (e.g 192.168.1.1)")}#вводим если не перадано аргументом
    if(!$IpA2){[string]$IpA2 = (Read-Host -Prompt "Enter Ip2 (e.g 192.168.1.2)")}
    if(!$NetMask){[string]$NetMask = (Read-Host -Prompt "Enter Network Mask (e.g 255.255.255.0)or Prefix(range 0-32)")}
         
    $NetMask = PreftoMask -Prefix $NetMask #преобразуем префикс в маску
    IpChecker -Ip1 $IpA1 -Ip2 $IpA2 -Mask $NetMask  #проверяем Ip и маску на валидность
    [string]$Net1="" #создаём переменные для хранения адреса сети
    [string]$Net2=""
    $Mask=$NetMask.Split(".")#сплит по точке, создаёт массив из 4х элементов, каждый элемент - октет маски или адреса
    $Ip1=$IpA1.Split(".")
    $Ip2=$IpA2.Split(".")
    
    for($i=0;$i -lt 4; $i++) #применяем логическое умножение И для каждого октета Ip и Маски
        {
            $Net1+=[string]([int]$Ip1[$i] -band [int]$Mask[$i])+"."#Получаем адреса сетей Net1 и Net2 для двух Ip
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
IpNetComp -IpA1 192.129.1.1 -IpA2 192.169.1.111 -NetMask 9

#2.	Работа с Hyper-V
#2.1.	Получить список коммандлетов работы с Hyper-V (Module Hyper-V)
Get-Command -Module Hyper-V
#2.2.	Получить список виртуальных машин
Get-VM
<# PS C:\Windows\system32> Get-VM

Name          State   CPUUsage(%) MemoryAssigned(M) Uptime           Status             Version
----          -----   ----------- ----------------- ------           ------             -------
Kochetkov_VM1 Running 0           512               00:02:34.8730000 Operating normally 9.0    
Kochetkov_VM2 Off     0           0                 00:00:00         Operating normally 9.0    
Kochetkov_VM3 Off     0           0                 00:00:00         Operating normally 9.0    
#>
#2.3.	Получить состояние имеющихся виртуальных машин
Get-VM(Get-VM).State
<#PS C:\Windows\system32> (Get-VM).State
Running
Off
Off
#>
#2.4.	Выключить виртуальную машину
Stop-VM -Name Kochetkov_VM1
<#PS C:\Windows\system32> Get-VM

Name          State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
----          ----- ----------- ----------------- ------   ------             -------
Kochetkov_VM1 Off   0           0                 00:00:00 Operating normally 9.0    
Kochetkov_VM2 Off   0           0                 00:00:00 Operating normally 9.0    
Kochetkov_VM3 Off   0           0                 00:00:00 Operating normally 9.0
#>   
#2.5.	Создать новую виртуальную машину
New-VM -Name Kochetkov_VM4 -MemoryStartupBytes 1GB -BootDevice VHD -NewVHDPath .Kochetkov_VM4.vhdx -NewVHDSizeBytes 20GB -Path "d:\virtual\" -Generation 2 -Switch Internal
Set-VMProcessor -VMName Kochetkov_VM4 -Count 2
<#Name          State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
----          ----- ----------- ----------------- ------   ------             -------
Kochetkov_VM4 Off   0           0                 00:00:00 Operating normally 9.0  
#>

#2.6.	Создать динамический жесткий диск
New-VHD -Path "d:\virtual\Kochetkov_VM4\Virtual Hard Disks\NewDisk.vhdx" -SizeBytes 10GB -Dynamic
<#ComputerName            : DESKTOP-I2G2MNU
Path                    : d:\virtual\Kochetkov_VM4\Virtual Hard Disks\NewDisk.vhdx
VhdFormat               : VHDX
VhdType                 : Dynamic
FileSize                : 4194304
Size                    : 10737418240
MinimumSize             : 
LogicalSectorSize       : 512
PhysicalSectorSize      : 4096
BlockSize               : 33554432
ParentPath              : 
DiskIdentifier          : A3F1E253-795E-4870-9C06-E5A1AC4B1132
FragmentationPercentage : 0
Alignment               : 1
Attached                : False
DiskNumber              : 
IsPMEMCompatible        : False
AddressAbstractionType  : None
Number    
#>
#2.7.	Удалить созданную виртуальную машину
Remove-VM -Name Kochetkov_VM4
<#PS C:\Windows\system32> Get-VM

Name          State CPUUsage(%) MemoryAssigned(M) Uptime   Status             Version
----          ----- ----------- ----------------- ------   ------             -------
Kochetkov_VM1 Off   0           0                 00:00:00 Operating normally 9.0    
Kochetkov_VM2 Off   0           0                 00:00:00 Operating normally 9.0    
Kochetkov_VM3 Off   0           0                 00:00:00 Operating normally 9.0    
#>

