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
        }
    }

    Node $AllNodes.Where{$_.Service -eq "SCCM"}.NodeName {
        cDSCMSCCM SCCMConfig
        {
            Role = $Node.Role
            DSLPath = $Node.DSLPath
        }
    }
}
