######################################################################################
# This is the master Build and Deploy script.
# Common variables are defined here to call configurations and configuationdata which
# are then used to crate all MOF files, checksums, and have the entire process
# deployed to the Pull Server
######################################################################################

######################################################################################
# Master Variables
######################################################################################
$Configuration = "MasterConfig"
$ConfigurationFile = "$env:HOMEDRIVE\DSC-Manager\Configuration\MasterConfig.ps1"
$ConfigurationData = "LabHosts"
$ConfigurationDataFile = "$env:HOMEDRIVE\DSC-Manager\ConfigurationData\Labhosts.ps1"
$SourceModules = "$env:PROGRAMFILES\WindowsPowershell\Modules"
$PullServerModules = "$env:PROGRAMFILES\WindowsPowershell\DscService\Modules"
#$PullServerConfiguration = "$env:PROGRAMFILES\WindowsPowershell\DscService\Configuration"
$PullServerConfiguration = "C:\_test"
$PullServerCertStore = "$env:PROGRAMFILES\WindowsPowershell\DscService\NodeCertificates"
$PullServerNodeCSV = "$env:PROGRAMFILES\WindowsPowershell\DscService\Management\dscnodes.csv"
$PasswordData = "$env:PROGRAMFILES\WindowsPowershell\DscService\Management\passwords.xml"

######################################################################################
# Import DSC-Management
######################################################################################
if(!(Get-Module cDSCManager)) {
    Try {
        Import-Module cDSCManager
        }
    Catch {
        Throw "Cannot load the DSC Management Tools.  Please make sure the module is present and the initial install has been run"
        }
    }

######################################################################################
# Run DSC-Management functions
######################################################################################

#Update the CSV table with missing Server,GUID, and Thumbprint information
Update-DSCMTable -ConfigurationData $ConfigurationData -ConfigurationDataFile $ConfigurationDataFile -FileName $PullServerNodeCSV -CertStore $PullServerCertStore

#Load ConfigurationData then add thumbprint information if available for final configuration application
$UpdatedConfigurationData = Update-DSCMConfigurationData -ConfigurationData $ConfigurationData -ConfigurationDataFile $ConfigurationDataFile -FileName $PullServerNodeCSV

#Create All Configuration MOFs based on updated data and place in respective Pull Server Configuration
Update-DSCMPullServer -Configuration $Configuration -ConfigurationFile $ConfigurationFile -ConfigurationData $UpdatedConfigurationData -PullServerConfiguration $PullServerConfiguration

#Update Pull Server module repo with current modules from the local repo
#Update-DSCMModules -SourceModules $SourceModules -PullServerModules $PullServerModules
