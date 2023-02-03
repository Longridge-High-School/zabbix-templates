# Variables
###########
# The host in zabbix, it's case sensative and the config file doesn't always supply it correctly.
$zabbixHost = "sophos-central"
# The Zabbix config file.
$configFile = 'C:\Program Files\Zabbix Agent\zabbix_agentd.conf'
# The temp file to store values in to send
$zabbixFile = "C:\scripts\zabbix\sophos-values.txt"
# The Server Address for Zabbix
$zabbixServer = ""
# The client ID from Sophos
$clientId = ""
#The Client secret from Sophos
$clientSecret = ""

# Internal Variables do not change.
$zabbixData = @()
$token = ""
$tenant = ""
$baseUrl = "https://api.central.sophos.com"

function Invoke-SophosAPIRequest(){
    param(
        [string]$Resource
    )

    $response = Invoke-WebRequest -Headers @{"Authorization" = "Bearer $token"; "X-Tenant-ID" = $tenant} -UseBasicParsing -Uri "$baseUrl$Resource"

    return ConvertFrom-JSON $response.Content
}

$response = Invoke-WebRequest -Method Post -Headers @{"Content-Type" = "application/x-www-form-urlencoded"} -Body "grant_type=client_credentials&client_id=$clientId&client_secret=$clientSecret&scope=token" -UseBasicParsing -Uri "https://id.sophos.com/api/v2/oauth2/token"
$authData = ConvertFrom-Json $response.Content

$token = $authData.access_token

$whoami = Invoke-SophosAPIRequest -Resource "/whoami/v1"

$baseUrl = $whoami.apiHosts.dataRegion
$tenant = $whoami.id

$health = Invoke-SophosAPIRequest -Resource "/account-health-check/v1/health-check"

$zabbixData += @{key = "sophos-central.endpoint.protection.computer.total"; value = $health.endpoint.protection.computer.total}
$zabbixData += @{key = "sophos-central.endpoint.protection.computer.nfp"; value = $health.endpoint.protection.computer.notFullyProtected}
$zabbixData += @{key = "sophos-central.endpoint.protection.server.total"; value = $health.endpoint.protection.server.total}
$zabbixData += @{key = "sophos-central.endpoint.protection.server.nfp"; value = $health.endpoint.protection.server.notFullyProtected}

$alerts = Invoke-SophosAPIRequest -Resource "/common/v1/alerts"

$alertsDiscovery = @{data = @()}

foreach($alert in $alerts.items){
    $alertId = $alert.id
    $alertsDiscovery.data += @{
        "{#ALERTID}" = $alertId
        "{#ALERTTITLE}" = $alert.description
    }

    $agentKey = "sophos-central.alerts.agent[$alertId]"
    $zabbixData += @{key = $agentKey; value = $alert.managedAgent.name}
}


$alertsJson = ConvertTo-JSON $alertsDiscovery -Compress
$encodedAlertsJson =  ([uri]::EscapeDataString($alertsJson))
$zabbixData += @{key = "sophos-central.alerts.discovery"; value = $encodedAlertsJson}

$endpointDiscovery = @{data=@()}

$endpointsResponse = Invoke-SophosAPIRequest -Resource "/endpoint/v1/endpoints"

$nextKey = $endpointsResponse.pages.nextKey
$endpoints = $endpointsResponse.items

while($nextKey -ne 0){
    $res = Invoke-SophosAPIRequest -Resource "/endpoint/v1/endpoints?pageFromKey=$nextKey"

    $endpoints += $res.items

    if($res.pages.nextKey){
        $nextKey = $res.pages.nextKey
    }else{
        $nextKey = 0
    }
}

foreach($endpoint in $endpoints){
    $endpointId = $endpoint.id

    $endpointDiscovery.data += @{
        "{#ENDPOINTID}" = $endpoint.id
        "{#ENDPOINTNAME}" = $endpoint.hostname
    }

    $zabbixData += @{key = "sophos-central.endpoints.overall-health[$endpointId]"; value = $endpoint.health.overall}
    $zabbixData += @{key = "sophos-central.endpoints.last-seen[$endpointId]"; value = ([DateTimeOffset]($endpoint.lastSeenAt)).ToUnixTimeSeconds()}
}

$endpointsJson = ConvertTo-JSON $endpointDiscovery -Compress
$encodedEndpointsJson =  ([uri]::EscapeDataString($endpointsJson))
$zabbixData += @{key = "sophos-central.endpoints.discovery"; value = $encodedEndpointsJson}

$zabbixString = ""
foreach($entry in $zabbixData){
    $zabbixString += '"'+ $zabbixHost + '" "' + $entry.key + '" "' + $entry.value + '"' + "`r`n"
}

$zabbixString.Trim() | Set-Content -Path $zabbixFile

& 'C:\Program Files\Zabbix Agent\zabbix_sender.exe' -c $configFile -s $zabbixHost -i $zabbixFile -z $zabbixServer
