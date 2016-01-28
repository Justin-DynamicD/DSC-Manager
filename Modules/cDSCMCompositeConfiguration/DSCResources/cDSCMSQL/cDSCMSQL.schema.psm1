Configuration cDSCMSQL 
{
    [cmdletBinding()]
    param (
        [Parameter(Mandatory=$false)][String]$WinSources = '\\FS-01\Deploymnent\Server_2012R2\Sources\SxS',
        [Parameter(Mandatory=$false)][String]$SQLSources = '\\FS-01\Deployment\SQL_2014',
        [Parameter(Mandatory=$true)][string]$NodeName,
        [Parameter(Mandatory=$true)][Array]$Role,
        [Parameter(Mandatory=$true)][Array]$SQLServers,
        [Parameter(Mandatory=$false)][Array]$SQLSysAdminAcct = "LAB\Domain Admins",
        [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$SQLSetupCred,
        [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$SQLSvcCred,
        [Parameter(Mandatory=$true)][System.Management.Automation.PSCredential]$SQLAgtSvcCred
        ) 

    Import-DscResource -Module xSQLServer
 
    #Prerequisite Installs
    WindowsFeature NetFramework35Core
        {
            Name = "NET-Framework-Core"
            Ensure = "Present"
            Source = $WinSources
        }
 
    WindowsFeature NetFramework45Core
        {
            Name = "NET-Framework-45-Core"
            Ensure = "Present"
            Source = $WinSources
        }
 
    #Install SQL Instances
    If ($Role -contains "Database") {
        foreach($SQLServer in $SQLServers) {
            $SQLInstanceName = $SQLServer.InstanceName
            $Features = "SQLENGINE"
                
            xSqlServerSetup ($NodeName + $SQLInstanceName)
            {
                DependsOn = "[WindowsFeature]NetFramework35Core","[WindowsFeature]NetFramework45Core"
                SourcePath = $SQLSources
                SourceFolder = "SQLServer2014.en"
                UpdateSource = "MU"
                INSTALLSHAREDDIR = "C:\Program Files\Microsoft SQL Server"
                INSTALLSHAREDWOWDIR = "C:\Program Files (x86)\Microsoft SQL Server"
                INSTANCEDIR = "C:\Program Files\Microsoft SQL Server"
                INSTALLSQLDATADIR = "D:\SQLServer"
                SQLSvcAccount = $SQLSvcCred
                AgtSvcAccount = $SQLAgtSvcCred
                SQLCOLLATION = "SQL_Latin1_General_CP1_CI_AS"
                SetupCredential = $SQLSetupCred
                InstanceName = $SQLInstanceName
                Features = $Features
                SQLSysAdminAccounts = $SQLSysAdminAcct
            }

            xSqlServerFirewall ($NodeName + $SQLInstanceName)
            {
                DependsOn = ("[xSqlServerSetup]" + $NodeName + $SQLInstanceName)
                SourcePath = $SQLSources
                SourceFolder = "SQLServer2014.en"
                InstanceName = $SQLInstanceName
                Features = $Features
            }
        }#End Per-Instance Install
    }#End Database Install

    #Install Management Tools
    If ($Role -contains "ManagementTools") {
        xSqlServerSetup "SQLMT"
            {
                DependsOn = "[WindowsFeature]NetFramework35Core","[WindowsFeature]NetFramework45Core"
                SourcePath = $SQLSources
                SourceFolder = "SQLServer2014.en"
                SetupCredential = $SQLSetupCred
                InstanceName = "NULL"
                Features = "SSMS,ADV_SSMS"
            }
        }
}
