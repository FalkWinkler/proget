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

    if($node)
    {
        $node.SetAttribute('value', $value)    
    }
    else
    {
        $newElement = $doc.CreateElement("add");
        $nameAtt1 = $doc.CreateAttribute("key")
        $nameAtt1.psbase.value = $key;
        $newElement.SetAttributeNode($nameAtt1);

        $nameAtt2 = $doc.CreateAttribute("value");
        $nameAtt2.psbase.value = $value;
        $newElement.SetAttributeNode($nameAtt2);
        
        $appsettingsNode = $doc.SelectSingleNode('//appSettings')

        $appsettingsNode.AppendChild($newElement);
    }    


    $doc.Save($config)
}

Update-AppSetting

