param(
    [string]$ConnectorID,
    [string]$RunProfileID,
    [string]$Property
)

$run = Get-ADSyncRunProfileResult -ConnectorId $ConnectorID -RunProfileId $RunProfileID -NumberRequested 1

if($Property -eq "result"){
    $run.Result
}

if($Property -eq "time"){
    ([DateTimeOffset]($run.EndDate.ToLocalTime())).ToUnixTimeSeconds()
}