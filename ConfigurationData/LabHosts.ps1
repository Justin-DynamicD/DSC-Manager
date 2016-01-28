# These variables are specfic settings for each target node that get applied to the DSC configiguration template
$LabHosts = @{ 
    AllNodes = @(
        @{ 
            NodeName = '*'
            DomainName = "lab.transformingintoaservice.com"
        },
        
        @{ 
            NodeName = "dc-01"
            Service = 'ActiveDirectory'
            Role = 'PDC'
            DNSServerAddresses = "192.168.1.102","127.0.0.1"
            Location = 'Private'
        },

        @{ 
            NodeName = "dc-02"
            Service = 'ActiveDirectory'
	        Role = 'DC'
            DNSServerAddresses = "192.168.1.100","127.0.0.1"
            Location = 'Private'
        },

         @{ 
            NodeName = "runbook-01"
            Service = 'DSC'
            Location = 'Private'
        },

         @{ 
            NodeName = "FS-01"
            Service = 'FileServer'
            Location = 'Private'
        },

         @{ 
            NodeName = "Gateway-01"
            Service = 'RDS'
            Role = 'Gateway'
            Location = 'Private'
        }

        <#
        @{ 
            NodeName = "example-01"
            Service = 'SQL'
            Role = 'Database', 'ManagementTools'
            SQLServers = @(
                @{
                    Role = @("Lab Converged Database Server")
                    InstanceName = "MSSQLSERVER"
                    }
                )
            Location = 'Private'
        }
        #>
    ); 
}
