$json = Get-Content -Path "C:\scripts\zabbix\veeam-data.json" -Raw

$data = ConvertFrom-JSON $json

$data.Created