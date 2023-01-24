param(
    [string]$Property,
    [string]$Site,
    [string]$Key,
    [string]$Value
)

# Required to allow self-signed certs.

add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
        public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
            WebRequest request, int certificateProblem) {
            return true;
        }
    }
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

$params = @{
    username = 'admin'
    password = 'PASSWORD'
}
$baseUrl = "https://unifi-url-here:8443"

$loginRequest = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/api/login" -SessionVariable session -Headers @{'Content-Type' = 'application/json'} -Body (ConvertTo-JSON $params) -Method Post

if($Property -eq "siteDiscovery"){
    $sitesRequest = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/api/self/sites" -WebSession $session -Headers @{'Content-Type' = 'application/json'}

    $sites = ConvertFrom-JSON $sitesRequest.Content

    $data = @()

    if($sites.data.Count -eq 1){
        $data += @{
                "{#SITENAME}" = $sites.data.name
            }
    }else{
        foreach($site in $sites.data){
        
            $data += @{
                "{#SITENAME}" = $site.name
            }
        }
    }

    ConvertTo-JSON @{data = $data}
}

if($Property -eq "siteHealth"){
    $siteHealthRequest = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/api/s/$Site/stat/health" -WebSession $session -Headers @{'Content-Type' = 'application/json'}

    $siteHealth = ConvertFrom-JSON $siteHealthRequest.Content

    foreach($system in $siteHealth.data){
        if($system.subsystem -eq $Key){
            $system."$Value"
        }
    }
}

if($Property -eq "deviceDiscovery"){
    $sitesRequest = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/api/self/sites" -WebSession $session -Headers @{'Content-Type' = 'application/json'}

    $sites = ConvertFrom-JSON $sitesRequest.Content

    if($sites.data.Count -eq 1){
        $scan = @($sites.data)
    }else{
        $scan = $sites.data
    }

    $data = @()

    foreach($s in $scan){
        $siteName = $s.name

        $siteDevicesRequest = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/api/s/$siteName/stat/device-basic" -WebSession $session -Headers @{'Content-Type' = 'application/json'}

        $devices = ConvertFrom-JSON $siteDevicesRequest.Content

        foreach($device in $devices.data){
            $data += @{
                "{#SITENAME}" = $siteName
                "{#DEVICENAME}" = $device.name
                "{#DEVICEMAC}" = $device.mac
            }
        }
    }

    ConvertTo-JSON @{data = $data}
}

if($Property -eq "deviceHealth"){
    $deviceHealthRequest = Invoke-WebRequest -UseBasicParsing -Uri "$baseUrl/api/s/$Site/stat/device/$Key" -WebSession $session -Headers @{'Content-Type' = 'application/json'}

    $data = ConvertFrom-JSON $deviceHealthRequest.Content

    $data.data."$Value"
}