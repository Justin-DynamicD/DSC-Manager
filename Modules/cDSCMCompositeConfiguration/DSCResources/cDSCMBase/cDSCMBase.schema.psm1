Configuration cDSCMBase
{
    param (
        [Parameter(Mandatory=$false)][array]$DNSServerAddresses,
        [Parameter(Mandatory=$false)][string]$Thumbprint,
        [Parameter(Mandatory=$true)][ValidateNotNullorEmpty()][string]$Location
        )
   
    Import-DSCResource -ModuleName @{ModuleName="xNetworking";ModuleVersion="2.7.0.0"}, @{ModuleName="cLCMCertManager";ModuleVersion="1.0.2"}, PSDesiredStateConfiguration

    #Per Location Site Codes
    If ($Location -eq "PrivateLab") {
        If (!$DNSServerAddresses) {$DNSServerAddresses = @('192.168.1.100','192.168.1.102')}
        $ServerURL = 'https://dsc.lab.transformingintoaservice.com:8080/PSDSCPullServer.svc'
        }

    #LCM Code
    LocalConfigurationManager {
        CertificateId = $Thumbprint
        RebootNodeIfNeeded = $true
        AllowModuleOverwrite = $true
        RefreshMode = "Pull"
        RefreshFrequencyMins = 30
        ConfigurationModeFrequencyMins = 60
        ConfigurationMode = "ApplyAndAutoCorrect"
        DownloadManagerCustomData = @{ServerURL = $ServerURL}
        }

    #Universal Code
    cLCMCertUpdate CertUpdateBase {
        OutPath = "\\DSC-01\CertStore"
        OutputName = "Computer"
        TemplateName = "Lab Computer"
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
         
    WindowsFeature DOTNET35 {
        Name = 'Net-Framework-Core'
        Ensure = 'Present'
        Source = '\\FS-01\Deployment\Server_2012R2\sources\SxS'
        }

    }

