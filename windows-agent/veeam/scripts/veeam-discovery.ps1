$json = Get-Content -Path "C:\scripts\zabbix\veeam-data.json" -Raw

$data = ConvertFrom-JSON $json

$content = '{"data":['

$n = $data.Backups.Count

foreach ($backup in $data.Backups) {
    $line =  ' { "{#JOBNAME}":"' + $backup.name + '" }'
    if ($n -gt 1){
        $line += ","
    }
    $content += $line
    $n--
}

$content += "]}"

$content