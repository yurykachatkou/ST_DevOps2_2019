#7.	Написать сценарий, выводящий суммарное время пингования компьютера (например 10.0.0.1) в сети.
$SumResp=0
for($i=0;$i -lt 10; $i++)
{
    $Resp = Get-WmiObject -Class Win32_PingStatus -Filter "Address='8.8.8.8'"
    $SumResp+=$Resp.ResponseTime

}
Write-Output $SumResp
