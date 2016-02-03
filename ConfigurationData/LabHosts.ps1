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
            Location = 'PrivateLab'
        },

        @{ 
            NodeName = "dc-02"
            Service = 'ActiveDirectory'
	        Role = 'DC'
            DNSServerAddresses = "192.168.1.100","127.0.0.1"
            Location = 'PrivateLab'
        },

         @{ 
            NodeName = "runbook-01"
            Service = 'DSC'
            Location = 'PrivateLab'
        },

         @{ 
            NodeName = "FS-01"
            Service = 'FileServer'
            Location = 'PrivateLab'
        },

         @{ 
            NodeName = "Gateway-01"
            Service = 'RDS'
            Role = 'Gateway'
            Location = 'PrivateLab'
        }

        @{ 
            NodeName = "example-01"
            Service = 'ActiveDirectory'
            Role = 'DC'
            Location = 'PrivateLab'
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
            Location = 'PrivateLab'
        }
        #>
    ); 
}
