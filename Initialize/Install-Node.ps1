#Compile Configuration for install
[DscLocalConfigurationManager()]
Configuration meta
{ 
    node localhost
    {
        Settings
        { 
            CertificateId = $NodeThumbprint;
            RefreshMode = "PULL";
            RebootNodeIfNeeded = $true;
            AllowModuleOverwrite = $true;
            RefreshFrequencyMins = 30;
            ConfigurationModeFrequencyMins = 60; 
            ConfigurationMode = "ApplyAndAutoCorrect";
        }

        ConfigurationRepositoryWeb ConfigurationManager
        {
            ServerURL = 'https://dsc.lab.transformingintoaservice.com:8080/PSDSCPullServer.svc'
            RegistrationKey = 'e1170789-4819-4f96-88d7-b1957e511751'
        }

    }
}  

meta
Start-DscConfiguration -wait -verbose .\meta -force
