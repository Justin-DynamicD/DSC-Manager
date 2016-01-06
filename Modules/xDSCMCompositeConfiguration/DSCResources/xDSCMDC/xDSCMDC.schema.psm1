configuration xDSCMDC 
{ 
    [cmdletBinding()]
    param (
        [Parameter(Mandatory=$false)][Array]$Role,
        [Parameter(Mandatory=$true)][String]$DomainName,
        [Parameter(Mandatory=$false)][Int]$RetryCount=20,
        [Parameter(Mandatory=$false)][Int]$RetryIntervalSec=30,
        [Parameter(Mandatory=$false)][ValidateNotNullorEmpty()][pscredential]$DCSafeModeAdministratorCred = $PSCmdlet.SessionState.PSVariable.GetValue('DCSafeModeAdministratorCred'), 
        [Parameter(Mandatory=$false)][ValidateNotNullorEmpty()][pscredential]$DCDomainCred = $PSCmdlet.SessionState.PSVariable.GetValue('DCDomainCred'),
        [Parameter(Mandatory=$false)][ValidateNotNullorEmpty()][pscredential]$DCDNSDelegationCred =$PSCmdlet.SessionState.PSVariable.GetValue('DCDNSDelegationCred')
        ) 

    Import-DscResource -ModuleName xActiveDirectory

    If ($Role -contains "PDC") {
        WindowsFeature ADDSInstall 
        { 
            Ensure = "Present" 
            Name = "AD-Domain-Services" 
        } 
        xADDomain FirstDS 
        { 
            DomainName = $DomainName 
            DomainAdministratorCredential = $DCDomainCred 
            SafemodeAdministratorPassword = $DCSafeModeAdministratorCred 
            DnsDelegationCredential = $DCDNSDelegationCred 
            DependsOn = "[WindowsFeature]ADDSInstall" 
        } 
        xWaitForADDomain DscForestWait 
        { 
            DomainName = $DomainName
            DomainUserCredential = $DCDomainCred 
            RetryCount = $RetryCount 
            RetryIntervalSec = $RetryIntervalSec 
            DependsOn = "[xADDomain]FirstDS" 
        } 
    } #End PDC

    If ($Role -contains "DC") { 
        WindowsFeature ADDSInstall 
        { 
            Ensure = "Present" 
            Name = "AD-Domain-Services" 
        }

        xWaitForADDomain DscForestWait 
        { 
            DomainName = $DomainName
            DomainUserCredential = $DCDomainCred 
            RetryCount = $RetryCount 
            RetryIntervalSec = $RetryIntervalSec 
            DependsOn = "[WindowsFeature]ADDSInstall" 
        }

        xADDomainController SecondDC 
        { 
            DomainName = $DomainName 
            DomainAdministratorCredential = $DCDomainCred 
            SafemodeAdministratorPassword = $DCSafeModeAdministratorCred
            DependsOn = "[xWaitForADDomain]DscForestWait" 
        } 
    } #End DC
} 