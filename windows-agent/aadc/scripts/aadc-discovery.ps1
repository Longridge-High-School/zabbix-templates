$runs = Get-ADSyncRunProfileResult -NumberRequested 6

write-host "{"
write-host " `"data`":["
write-host
	
$n = $runs.Count

foreach ($run in $runs) {
    $line =  ' { "{#CONNECTORNAME}":"' + $run.ConnectorName + '" ,"{#RUNSTEP}":"' + $run.RunProfileName  +
                    '", "{#CONNECTORID}":"' + $run.ConnectorID + '", "{#RUNPROFILEID}":"' + $run.RunProfileId + '" }'
    if ($n -gt 1){
        $line += ","
    }
    write-host $line
    $n--
}

write-host " ]"
write-host "}"
write-host