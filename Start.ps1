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
   
   
Update-AppSetting -config c:\app\service\App_appSettings.config -value $connectionString
Update-AppSetting -config c:\inetpub\wwwroot\Web_appSettings.config -key ProGetConfig.Storage.PackagesRootPath -value c:\ProgramData\Proget\packages
Update-AppSetting -config c:\inetpub\wwwroot\Web_appSettings.config -value $connectionString

c:\app\db\bmdbupdate.exe Update /conn=$connectionString /Init=yes

c:\app\service\ProGet.Service.exe "Install"

c:\ServiceMonitor.exe w3svc
