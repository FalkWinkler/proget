$env:PROGET_VERSION="5.0.12"
Invoke-WebRequest -Uri $('https://s3.amazonaws.com/cdn.inedo.com/downloads/proget/ProGetSetup{0}_Manual.zip' -f $env:PROGET_VERSION)  -UseBasicParsing -OutFile 'ProGetSetup.exe'

docker build --rm -f Dockerfile -t proget:latest .

