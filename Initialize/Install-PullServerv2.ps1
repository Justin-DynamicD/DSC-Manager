
Configuration V2PullServer
{
    param(
            [Parameter(Mandatory=$false)][string] $NodeName = $env:ComputerName,
            [Parameter(Mandatory=$true)][ValidateNotNullOrEmpty()][string] $SSLCertThumbprint
        )

    Import-DscResource -ModuleName xPsDesiredStateConfiguration
    Import-DscResource -ModuleName xWebAdministration

    node $NodeName
    {
        WindowsFeature DSCServiceFeature
        {
            Ensure = "Present"
            Name   = "DSC-Service"            
        }

        WindowsFeature WinAuth 
        { 
            Ensure = "Present" 
            Name   = "web-Windows-Auth"             
        } 

        xDscWebService PSDSCPullServer
        {
            Ensure                       = "Present"
            EndpointName                 = "PSDSCService"
            Port                         = 8080
            PhysicalPath                 = "$env:SystemDrive\inetpub\PullServer"
            CertificateThumbPrint        = $SSLCertThumbprint
            ModulePath                   = "$env:ProgramFiles\WindowsPowerShell\DscService\Modules"
            ConfigurationPath            = "$env:ProgramFiles\WindowsPowerShell\DscService\Configuration"
            State                        = "Started"
            DependsOn                    = "[WindowsFeature]DSCServiceFeature"
        }

        xDscWebService PSDSCComplianceServer
        {
            Ensure                       = "Present"
            EndpointName                 = "PSDSCCompliance"
            Port                         = 9080
            PhysicalPath                 = "$env:SystemDrive\inetpub\ComplianceServer"
            CertificateThumbPrint        = "AllowUnencryptedTraffic"
            State                        = "Started"
            IsComplianceServer           = $true
            DependsOn                    = @("[WindowsFeature]DSCServiceFeature","[WindowsFeature]WinAuth","[xDSCWebService]PSDSCPullServer")
        }

        WindowsFeature WebManagementTools
        {
            Ensure = "Present"
            Name = "Web-Mgmt-Console"
            DependsOn = "[xDSCWebService]PSDSCPullServer"
        }

        File RegistrationKeyFile
        {
            Ensure           ='Present'
            Type             = 'File'
            DestinationPath  = "$env:ProgramFiles\WindowsPowerShell\DscService\RegistrationKeys.txt"
            Contents         = 'e1170789-4819-4f96-88d7-b1957e511751'
        }
    }
}


$SSLThumbprint = "20E26E306E2B4AA0135A6D6181EC25249689211F"
              
V2PullServer -SSLCertThumbprint $SSLThumbprint
Start-DscConfiguration -wait -verbose .\V2PullServer -force
