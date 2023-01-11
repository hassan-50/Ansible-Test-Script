# sould be run with admin privileges
param (
    $apmUrl = "10.1.4.9"
)
If (!(test-path -PathType container "C:\AvianCloud"))
{
    New-Item -ItemType Directory -Force -Path "C:\AvianCloud"
}
If (!(test-path -PathType container "C:\AvianCloud\dashboard"))
{
    New-Item -ItemType Directory -Force -Path "C:\AvianCloud\dashboard"
}
If (!(test-path -PathType container "C:\AvianCloud\dashboard\agent"))
{
    New-Item -ItemType Directory -Force -Path "C:\AvianCloud\dashboard\agent"
}
Set-Location 'C:\AvianCloud\dashboard\agent'
# download the jar file
Invoke-WebRequest -UseBasicParsing "https://search.maven.org/remotecontent?filepath=co/elastic/apm/elastic-apm-agent/1.35.0/elastic-apm-agent-1.35.0.jar"  -OutFile "C:\AvianCloud\dashboard\agent\elastic-apm-agent.jar"
# create the config file
New-Item -Path "C:\AvianCloud\dashboard\agent" -Name "elasticapm.properties" -ItemType "file" -Force -Value @"
application_packages=com.nuix
server_url=$apmUrl
hostname=nuix-invest
environment=Production
capture_body=true
central_config=true
enable_jaxrs_annotation_inheritance
use_jaxrs_path_as_transaction_name
profiling_inferred_spans_enabled=true
"@
If (!(test-path -PathType container "C:\Program Files\Nuix"))
{
    New-Item -ItemType Directory -Force -Path "C:\Program Files\Nuix"
}
If (!(test-path -PathType container "C:\Program Files\Nuix\Web Platform"))
{
    New-Item -ItemType Directory -Force -Path "C:\Program Files\Nuix\Web Platform"
}
If (!(test-path -PathType container "C:\Program Files\Nuix\Web Platform\Nuix-Config"))
{
    New-Item -ItemType Directory -Force -Path "C:\Program Files\Nuix\Web Platform\Nuix-Config"
}
If (!(test-path -PathType container "C:\Program Files\Nuix\Web Platform\Nuix-Config\properties"))
{
    New-Item -ItemType Directory -Force -Path "C:\Program Files\Nuix\Web Platform\Nuix-Config\properties"
}
If (!(test-path -PathType container "C:\Program Files\Nuix\Web Platform\Nuix-Config\properties\investigate"))
{
    New-Item -ItemType Directory -Force -Path "C:\Program Files\Nuix\Web Platform\Nuix-Config\properties\investigate"
}
# check file existance
If (!(test-path -PathType leaf "C:\Program Files\Nuix\Web Platform\Nuix-Config\properties\investigate\application.vmoptions"))
{
    New-Item -Path "C:\Program Files\Nuix\Web Platform\Nuix-Config\properties\investigate" -Name "application.vmoptions" -ItemType "file" -Force -Value @"
-javaagent:C:\AvianCloud\dashboard\agent\elastic-apm-agent.jar
-Delastic.apm.service_name=Nuix_Investigate_JVM
"@
}
else
{
    Add-Content -Path "C:\Program Files\Nuix\Web Platform\Nuix-Config\properties\investigate\application.vmoptions" -Value @"
-javaagent:C:\AvianCloud\dashboard\agent\elastic-apm-agent.jar
-Delastic.apm.service_name=Nuix_Investigate_JVM
"@
}