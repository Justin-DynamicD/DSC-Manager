# These variables are specfic settings for each target node that get applied to the DSC configiguration template
$LabHosts = @{ 
    AllNodes = @(
        
        @{ 
            NodeName = "dc-01"
            Service = 'ActiveDirectory'
            Role = 'PDC'
            DomainName = "lab.transformingintoaservice.com"
            DNSServerAddresses = "192.168.1.102","127.0.0.1"
            Location = 'Private'
        },

        @{ 
            NodeName = "dc-02"
            Service = 'ActiveDirectory'
	        Role = 'DC'
            DomainName = "lab.transformingintoaservice.com"
            DNSServerAddresses = "192.168.1.100","127.0.0.1"
            Location = 'Private'
        },

         @{ 
            NodeName = "runbook-01"
            Service = 'DSC'
            DomainName = "lab.transformingintoaservice.com"
            Location = 'Private'
        },

         @{ 
            NodeName = "FS-01"
            Service = 'FileServer'
            DomainName = "lab.transformingintoaservice.com"
            Location = 'Private'
        },

         @{ 
            NodeName = "Gateway-01"
            Service = 'RDS'
            Role = 'Gateway'
            DomainName = "lab.transformingintoaservice.com"
            Location = 'Private'
        }
    ); 
}
