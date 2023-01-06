# sould be run with admin privileges
param (
    $logPath = "C:\Program Files\Nuix\Web Platform\Nuix-Investigate\logs",
    $logstahUrl = "http://localhost:5044"
)
​
# install powershell-yaml module, and import it
# Install-Module -Name powershell-yaml -Force -Verbose -Scope CurrentUser
Import-Module powershell-yaml
​
# change location to C:
Set-Location 'C:\'
​
# Download Filebeat
Invoke-WebRequest -UseBasicParsing "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-8.5.2-windows-x86_64.zip"  -OutFile "C:\Filebeat.zip"
# Expand-Archive -Path "C:\Filebeat.zip"
Expand-Archive "C:\Filebeat.zip" -DestinationPath "C:\Program Files"
​
# remove the zip file, and rename the extracted folder
Remove-Item .\Filebeat.zip
Rename-Item "C:\Program Files\filebeat-8.5.2-windows-x86_64" "C:\Program Files\filebeat"
​
# cd dir to filebeat folder
Set-Location 'C:\Program Files\Filebeat'
​
# path to the filebeat.yml file
$filebeatConfigPath = "C:\Program Files\filebeat\filebeat.yml"
​
# config filebeat.yml
$filebeatConfig = ConvertTo-Yaml @{
    "filebeat.inputs"= @(@{
        "type"="log";
        "paths"= @($logPath);
        "id"="nuix-file-beat";
        "enabled"= $true;
        "multiline.pattern"="'^[0-9]{4}-[0-9]{2}-[0-9]{2}'"
        "multiline.negate"="true"
        "multiline.match"="after"
    })
    "output.logstash"=@{
        "hosts"=@("$($logstahUrl)")
    }
    "processors"=@{
        "add_host_metadata"=@{"when.not.contains.tags"="forwarded"}
        "add_cloud_metadata"="~"
        "add_docker_metadata"="~"
        "add_kubernetes_metadata"="~"
    }
}
​
# Write the YML file
set-content -path $filebeatConfigPath -value $filebeatConfig
​
# start filebeat
.\filebeat.exe -c $filebeatConfigPath -e