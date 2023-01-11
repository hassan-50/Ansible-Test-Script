# sould be run with admin privileges
param (
    $elasticUrl = "10.1.4.7:9200",
    $elasticUser = "elastic",
    $elasticPassword = "SP41015I52j1mqZBTOL4rk2i"
)
# install powershell-yaml module, and import it
# Install-Module -Name powershell-yaml -Force -Verbose -Scope CurrentUser
Import-Module powershell-yaml
# change location to C:
Set-Location 'C:\'
############################################################################################################
# Download Filebeat
Invoke-WebRequest -UseBasicParsing "https://artifacts.elastic.co/downloads/logstash/logstash-8.5.3-windows-x86_64.zip"  -OutFile "C:\Logstash.zip"
# Expand-Archive -Path "C:\Logstash.zip"
Expand-Archive "C:\Logstash.zip" -DestinationPath "C:\Program Files"
## remove the zip file, and rename the extracted folder
Remove-Item .\Logstash.zip
Rename-Item "C:\Program Files\logstash-8.5.3" "C:\Program Files\logstash"
############################################################################################################
# cd dir to logstash folder
Set-Location 'C:\Program Files\logstash'
# path to the pipelines.yml file
$logstashConfigPath = "C:\Program Files\logstash\config\pipelines.yml"
# config pipelines.yml
$logstashConfig = ConvertTo-Yaml @(@{
    "pipeline.id"="main";
    "path.config"="C:\Program Files\logstash\config\pipelines\main.config";
})
############################################################################################################
# Write the YML file
set-content -path $logstashConfigPath -value $logstashConfig
# create the pipelines folder
New-Item -ItemType Directory -Force -Path "C:\Program Files\logstash\config\pipelines"
# create the main.config file
New-Item -Path "C:\Program Files\logstash\config\pipelines" -Name "main.config" -ItemType "file" -Force -Value @"
input {
  beats {
    port => 5044
    ssl => false
  }
}
filter {
  grok {
	match => { "message" => "%{TIMESTAMP_ISO8601:timestamp} \[%{DATA:mainclass}\] %{LOGLEVEL:loglevel} %{NOTSPACE:subClass} \- (?<msg>.+?(?=(\r\n|\r|\n)))(?<stacktrace>.+)" }
  }
}
output {
    elasticsearch {
    hosts => ["$elasticUrl"]
    index => "nuix-%{+YYYY.MM.dd}"
    user => "$elasticUser"
    password => "$elasticPassword"
    }
}
"@
# run logstash with pipelines.yml
# .\bin\logstash