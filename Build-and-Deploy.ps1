######################################################################################
# This is the master Build and Deploy script.
# Common variables are splat here to call configurations and configuationdata which
# are then used to crate all MOF files, checksums, and have the entire process
# deployed to the Pull Server
######################################################################################

$Parameters = @{
    Configuration = "MasterConfig"
    ConfigurationFile = "$env:HOMEDRIVE\DSC-Manager\Configuration\MasterConfig.ps1"
    ConfigurationData = "LabHosts"
    ConfigurationDataFile = "$env:HOMEDRIVE\DSC-Manager\ConfigurationData\Labhosts.ps1"
    SourceModules = "$env:PROGRAMFILES\WindowsPowershell\Modules"
    PullServerModules = "$env:PROGRAMFILES\WindowsPowershell\DscService\Modules"
    PullServerConfiguration = "$env:PROGRAMFILES\WindowsPowershell\DscService\Configuration"
    #PullServerConfiguration = "C:\_test"
    PullServerCertStore = "$env:PROGRAMFILES\WindowsPowershell\DscService\NodeCertificates"
    PullServerNodeCSV = "$env:PROGRAMFILES\WindowsPowershell\DscService\Management\dscnodes.csv"
    PasswordData = "$env:PROGRAMFILES\WindowsPowershell\DscService\Management\passwords.xml"
    }


######################################################################################
# Run DSC-Management functions
######################################################################################

#Update the CSV table with missing Server,GUID, and Thumbprint information
[PSCustomObject]$Parameters | Update-DSCMTable

#Load ConfigurationData then add thumbprint information if available for final configuration application
$UpdatedConfigurationData = ([PSCustomObject]$Parameters | Update-DSCMConfigurationData)

#Create All Configuration MOFs based on updated data and place in respective Pull Server Configuration
[PSCustomObject]$Parameters | Update-DSCMPullServer -ConfigurationData $UpdatedConfigurationData

#Update Pull Server module repo with current modules from the local repo
#Update-DSCMModules @Parameters
