Configuration cDSCMBase
{
    param (
        [Parameter(Mandatory=$false)][array]$DNSServerAddresses,
        [Parameter(Mandatory=$false)][string]$Thumbprint,
        [Parameter(Mandatory=$true)][ValidateNotNullorEmpty()][string]$Location
        )
   
    Import-DSCResource -ModuleName xNetworking

    #Per Location Site Codes
    If ($Location -eq "PrivateLab") {
        If (!$DNSServerAddresses) {$DNSServerAddresses = @('192.168.1.100','192.168.1.102')}
        $ServerURL = 'https://dsc.lab.transformingintoaservice.com:8080/PSDSCPullServer.svc'
        }
    

    xDNSServerAddress  DNSBase {
                Address = $DNSServerAddresses
                InterfaceAlias = "Ethernet"
                AddressFamily = "IPV4"
                }

    xDnsConnectionSuffix DNSuffixBase {
        InterfaceAlias = "Ethernet"
        ConnectionSpecificSuffix = "lab.transformingintoaservice.com"
        }
         

    LocalConfigurationManager {
        CertificateId = $Thumbprint
        RebootNodeIfNeeded = $true
        AllowModuleOverwrite = $true
        RefreshMode = "Pull"
        RefreshFrequencyMins = 15
        ConfigurationModeFrequencyMins = 30
        ConfigurationMode = "ApplyAndAutoCorrect"
        DownloadManagerCustomData = @{ServerURL = $ServerURL}
        }

    }

