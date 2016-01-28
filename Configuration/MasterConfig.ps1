Configuration MasterConfig
{
    Import-DscResource -Module cDSCMCompositeConfiguration

    Node $AllNodes.NodeName {    
        cDSCMBase BaseConfig
        {
            DNSServerAddresses = $Node.DNSServerAddresses
            Location =$Node.Location
        }
    }

    Node $AllNodes.Where{$_.Service -eq "ActiveDirectory"}.NodeName {
        cDSCMActiveDirectory DCConfig
        {
            Role = $Node.Role
            DomainName = $Node.DomainName
            DCSafeModeAdministratorCred = $Node.DCSafeModeAdministratorCred
            DCDomainCred = $Node.DCDomainCred
            DCDNSDelegationCred = $Node.DCDNSDelegationCred
        }
    }

    Node $AllNodes.Where{$_.Service -eq "SCCM"}.NodeName {
        cDSCMSCCM SCCMConfig
        {
            Role = $Node.Role
            DSLPath = $Node.DSLPath
            SCCMAdministratorCredential = $Node.SCCMAdministratorCredential
        }
    }

    Node $AllNodes.Where{$_.Service -eq "SQL"}.NodeName {
        cDSCMSQL SQLConfig
        {
            NodeName = $Node.NodeName
            Role = $Node.Role
            SQLServers = $Node.SqlServers
            SQLSetupCred = $Node.SQLSetupCred
            SQLSvcCred = $Node.SQLSvcCred
            SQLAgtSvcCred = $Node.SQLSvcCred
        }
    }
}
