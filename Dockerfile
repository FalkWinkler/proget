# escape=`
FROM microsoft/aspnet:4.7.1-windowsservercore-ltsc2016

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
VOLUME c:\ProgramData\proget

ENV LicenseKey MH3JNEEF-E8J4-JHDBHY-J0G4PN-S292NECK
ENV PROGET_VERSION 5.0.12

# download geht immer irgendwie nicht, ka warum. auf der REchner selber funktioniert das
#RUN Invoke-WebRequest -Uri $('https://s3.amazonaws.com/cdn.inedo.com/downloads/proget/ProGetSetup{0}_Manual.zip' -f $env:PROGET_VERSION)  -UseBasicParsing -OutFile 'ProGetSetup.zip'
COPY ProGetSetup.zip progetsetup.zip

RUN MD /app

RUN Expand-Archive progetsetup.zip -DestinationPath C:\ ; `
    Expand-Archive ProGet-WebApp.zip -DestinationPath C:\inetpub\wwwroot\ ; `
    Expand-Archive ProGet-Service.zip -DestinationPath C:\app\service ; `
    Expand-Archive ProGet-DbChangeScripter.zip -DestinationPath c:\app\db ;

COPY Update-AppSetting.ps1 Update-AppSetting.ps1
COPY Start.ps1 Start.ps1

ENV PROGET_DATABASE "Server=proget-postgres; Database=postgres; User Id=postgres; Password=;"

EXPOSE 80

ENTRYPOINT .\\Start.ps1