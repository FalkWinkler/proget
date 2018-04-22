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

Update-AppSetting

