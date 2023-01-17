Start-Transcript -Path C:\scripts\zabbix\veeam-data-builder.txt

$backups = Get-VBRBackup

$data = New-Object PSObject -Property @{
    Backups = @()
    Created = ([DateTimeOffset](Get-Date)).ToUnixTimeSeconds()
    TotalSize = 0
}

foreach ($backup in $backups) {
    $job = Get-VBRJob -name $backup.Name

    $data.Backups += @{
        name = $backup.Name
        size = $job.Info.IncludedSize
        result = $job.Info.LatestStatus.ToString()
        time = ([DateTimeOffset]($job.LatestRunLocal)).ToUnixTimeSeconds()
    }

    $data.TotalSize += $job.Info.IncludedSize
}

$data | ConvertTo-Json | Set-Content -Path "C:\scripts\zabbix\veeam-data.json"

Stop-Transcript