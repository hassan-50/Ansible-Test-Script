Get-Command -Module SimplySql
# Define clear text string for username and password
[string]$userName = 'root'
[string]$userPassword = 'P@ssword'

# Convert to SecureString
[securestring]$secStringPassword = ConvertTo-SecureString $userPassword -AsPlainText -Force

# Add credentials to credObject
[pscredential]$credObject = New-Object System.Management.Automation.PSCredential ($userName, $secStringPassword)

# Open Mysql Connection
open-mysqlconnection -Server "localhost" -Credential $credObject

# Create First Database
invoke-sqlquery -query "create database ums;"

# Create Second Database
invoke-sqlquery -query "create database wr;"