# VEEAM Data Sending
# Uses Zabbix send to send data directly to Zabbix
#
#
# Variables
###########
# The host in zabbix, it's case sensative and the config file doesn't always supply it correctly.
$zabbixHost = "<hostname>"
# The Zabbix config file.
$configFile = 'C:\Program Files\Zabbix Agent\zabbix_agentd.conf'
# The temp file to store values in to send
$zabbixFile = "C:\scripts\zabbix\veeam-values.txt"

Start-Transcript -Path C:\scripts\zabbix\veeam.txt

$zabbixData = @()

$backups = Get-VBRBackup

$jobDiscovery = @{data = @()}

foreach ($backup in $backups) {
    $job = Get-VBRJob -Name $backup.Name

    if($job){
        $jobDiscovery.data += @{
            "{#JOBNAME}" = $backup.Name
        }

        $jobName = $backup.Name

        $lastResultKey = "veeam.jobs.details[$jobName,result]"
        $lastResult = $job.Info.LatestStatus.ToString()

        $zabbixData += @{key = $lastResultKey; value = $lastResult}

        $timeKey = "veeam.jobs.details[$jobName,time]"
        $backupTime = ([DateTimeOffset]($job.LatestRunLocal)).ToUnixTimeSeconds()

        if($job.LinkedJobs.Count -gt 0){
            $childJobs = $job.GetWorkerJobs()

            foreach($childJob in $childJobs){
                if(([DateTimeOffset]($childJob.LatestRunLocal)).ToUnixTimeSeconds() -gt $backupTime){
                    $backupTime = ([DateTimeOffset]($childJob.LatestRunLocal)).ToUnixTimeSeconds() 
                }
            }
        }

        $zabbixData += @{key = $timeKey; value = $backupTime}

        $sizeKey = "veeam.jobs.details[$jobName,size]"
        $size = $job.Info.IncludedSize

        $zabbixData += @{key = $sizeKey; value = $size}


    }  
}

$jobsJson = ConvertTo-JSON $jobDiscovery -Compress

$encodedJobsJson =  ([uri]::EscapeDataString($jobsJson))

$zabbixData += @{key = "veeam.jobs.discovery"; value = $encodedJobsJson}

$pools = Get-VBRTapeMediaPool

$poolDiscovery = @{data = @()}
$tapeDiscovery = @{data = @()}

foreach($pool in $pools){
    $poolDiscovery.data += @{"{#MEDIAPOOL}" = $pool.Name}

    $poolLastWrite = 0
    $poolLastTape = "none"
    $poolName = $pool.Name

    foreach($tape in $pool.Medium){
        $lastWrite = ([DateTimeOffset]($tape.LastWriteTime)).ToUnixTimeSeconds()

        if($lastWrite -gt $poolLastWrite){
            $poolLastWrite = $lastWrite
            $poolLastTape = $tape.Name
        }

        $tapeDiscovery.data += @{
            "{#MEDIAPOOL}" = $poolName
            "{#TAPENAME}" = $tape.Name
        }

        $tapeName = $tape.Name

        $capacityKey = "veeam.tapes.details[$poolName,$tapeName, Capacity]"
        $zabbixData += @{key = $capacityKey; value = $tape.Capacity}

        $writeKey = "veeam.tapes.details[$poolName,$tapeName, LastWrite]"
        $zabbixData += @{key = $writeKey; value = $lastWrite}
    }

    $lastTapeKey = "veeam.pools.details[$poolName,LastTape]"

    $zabbixData += @{key = $lastTapeKey; value = $poollastTape}

    $lastWriteKey = "veeam.pools.details[$poolName,LastWrite]"

    $zabbixData += @{key = $lastWriteKey; value = $poolLastWrite}

}

$poolsJson = ConvertTo-JSON $poolDiscovery -Compress

$encodedPoolsJson =  ([uri]::EscapeDataString($poolsJson))

$zabbixData += @{key = "veeam.pools.discovery"; value = $encodedPoolsJson}

$tapesJson = ConvertTo-JSON $tapeDiscovery -Compress

$encodedTapesJson =  ([uri]::EscapeDataString($tapesJson))

$zabbixData += @{key = "veeam.tapes.discovery"; value = $encodedTapesJson}


$zabbixString = ""
foreach($entry in $zabbixData){
    $zabbixString += '"'+ $zabbixHost + '" "' + $entry.key + '" "' + $entry.value + '"' + "`r`n"
}

$zabbixString.Trim() | Set-Content -Path $zabbixFile

& 'C:\Program Files\Zabbix Agent\zabbix_sender.exe' -c $configFile -s $zabbixHost -i $zabbixFile

Stop-Transcript