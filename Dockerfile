# escape=`
FROM microsoft/aspnet:4.7.1-windowsservercore-ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
VOLUME c:\packages

ENV LicenseKey MH3JNEEF-E8J4-JHDBHY-J0G4PN-S292NECK

#ENV FeedName testfalk
#COPY ProGetSetup.exe ProGetSetup.exe
#RUN Start-Process -FilePath (Join-Path $pwd ProGetSetup.exe) -ArgumentList '/S', '/Edition=LicenseKey', '/LicenseKey=MH3JNEEF-E8J4-JHDBHY-J0G4PN-S292NECK', '/TargetPath=c:\app' ,'/LogFile=c:\install.log' , '/InstallSqlExpress'  -NoNewWindow -Wait

COPY ProGetSetup.zip progetsetup.zip

RUN MD /app

RUN Expand-Archive progetsetup.zip -DestinationPath C:\ ; `
    Expand-Archive ProGet-WebApp.zip -DestinationPath C:\inetpub\wwwroot\ ; `
    Expand-Archive ProGet-Service.zip -DestinationPath C:\app\service ; `
    Expand-Archive ProGet-DbChangeScripter.zip -DestinationPath c:\app\db ;

COPY Update-AppSetting.ps1 Update-AppSetting.ps1
COPY Start.ps1 Start.ps1

#RUN Start-Process -FilePath (Join-Path $pwd ProGetSetup.exe) -ArgumentList ('/S', '/Edition=LicenseKey', "/LicenseKey=$LicenseKey") -Wait -PassThru
ENV PROGET_DATABASE "Server=proget-postgres; Database=postgres; User Id=postgres; Password=;"

EXPOSE 80

ENTRYPOINT .\\Start.ps1