param(  
   [string]$connectionString = $env:PROGET_DATABASE
   )

function Update-AppSetting
{
    param(
     [ValidateScript({
                if( -Not ($_ | Test-Path) ){
                    throw "File or folder does not exist"
                }
                return $true
            })]
    [Parameter(Mandatory=$true)][System.IO.FileInfo]$config,
    [Parameter(Mandatory=$true)][string]$value,
    [Parameter(Mandatory=$false)][string]$key = "InedoLib.DbConnectionString"

    )

    
    [xml]$doc = Get-Content -Path $config 
    $node = $doc.SelectSingleNode('//appSettings/add[@key="' + $key + '"]')
    $node.SetAttribute('value', $value) > $null
    $doc.Save($config)
}

PING.EXE proget-postgres
   
Update-AppSetting -config c:\app\service\App_appSettings.config -value $connectionString
Update-AppSetting -config c:\inetpub\wwwroot\Web_appSettings.config -value $connectionString

c:\app\db\bmdbupdate.exe Update /conn=$connectionString /Init=yes
#c:\app\db\ProGet.Service.exe Install

c:\ServiceMonitor.exe w3svc
