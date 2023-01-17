param(
    [string]$JobName,
    [string]$Property
)

$json = Get-Content -Path "C:\scripts\zabbix\veeam-data.json" -Raw

$data = ConvertFrom-JSON $json

foreach($backup in $data.Backups){
    if($backup.name -eq $JobName){
        write-host $backup."$Property"
    }
}