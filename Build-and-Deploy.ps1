#This parameter hastable contains common locations for "stuff" in order to completely build/push mof configuraitons
$Parameters = @{
    Configuration = "MasterConfig"
    ConfigurationFile = "$env:HOMEDRIVE\DSC-Manager\Configuration\MasterConfig.ps1"
    ConfigurationDataFile = "$env:HOMEDRIVE\DSC-Manager\ConfigurationData\Labhosts.ps1"
    PullServerConfiguration = "$env:PROGRAMFILES\WindowsPowershell\DscService\Configuration"
    #PullServerConfiguration = "C:\_test"
    CertStore = "$env:PROGRAMFILES\WindowsPowershell\DscService\NodeCertificates"
    PasswordData = "$env:PROGRAMFILES\WindowsPowershell\DscService\passwords.xml"
    GUIDData = "$env:PROGRAMFILES\WindowsPowershell\DscService\dscnodes.csv"
    TempPath = "C:\temp"
    }

#Import the listed ConfigurationData, then modify it with appropriate Password and Thumbprint Information
$ConfigurationData = Invoke-Expression $Parameters.ConfigurationDataFile
$ConfigurationData = Update-ConfigurationDataCertificates -ConfigurationData $ConfigurationData -CertStore $Parameters.CertStore
$ConfigurationData = Update-ConfigurationDataPasswords -ConfigurationData $ConfigurationData -PasswordData $Parameters.PasswordData
$ConfigurationData = Update-ConfigurationDataNames -ConfigurationData $ConfigurationData -GUIDData $Parameters.GUIDData

#generate MOF files using Configurationdata and output to the appropriate temporary path
$ImportConfig = ". "+$Parameters.ConfigurationFile
$GenerateMof = $Parameters.Configuration+" -ConfigurationData `$ConfigurationData -outputpath `$Parameters.TempPath"
Invoke-Expression $ImportConfig
Invoke-Expression $GenerateMof | Out-Null

#create a checksum file for eah generated MOF
New-DSCCheckSum -ConfigurationPath $Parameters.TempPath -OutPath $Parameters.TempPath -Force

#All Generation is complete, now copy it all to the Pull Server
$SourceFiles = $Parameters.TempPath + "\*.mof*"
Move-Item $SourceFiles -Destination $Parameters.PullServerConfiguration -Force
