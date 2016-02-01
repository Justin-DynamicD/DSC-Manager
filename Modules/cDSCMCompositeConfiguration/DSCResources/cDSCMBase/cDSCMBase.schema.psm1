Configuration cDSCMBase
{
    param (
        [Parameter(Mandatory=$false)][array]$DNSServerAddresses,
        [Parameter(Mandatory=$true)][ValidateNotNullorEmpty()][string]$Location
        )
   
    Import-DSCResource -ModuleName xNetworking

    LocalConfigurationManager {
        RebootNodeIfNeeded = $true
        AllowModuleOverwrite = $true
        RefreshFrequencyMins = 15
        ConfigurationModeFrequencyMins = 30
        ConfigurationMode = "ApplyAndAutoCorrect"
        }

    If ($DNSServerAddresses) {
        xDNSServerAddress  DNSCustom {
            Address = $DNSServerAddresses
            InterfaceAlias = "Ethernet"
            AddressFamily = "IPV4"
            }
        }

    If (($Location -eq "PrivateLab") -and !($DNSServerAddresses)) {
        xDNSServerAddress  DNSPrivateLab {
            Address = "192.168.1.100","192.168.1.102"
            InterfaceAlias = "Ethernet"
            AddressFamily = "IPV4"
            }

        xDnsConnectionSuffix DNSuffixPrivateLab {
            InterfaceAlias = "Ethernet"
            ConnectionSpecificSuffix = "lab.transformingintoaservice.com"
            }

        }
}
