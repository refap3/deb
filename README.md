# deb
various patches 4 debian 8 etc.

patch_xxx patches feature xxx
install_xxx install feature xxx


remaining files are sources

### notes on dotnet: 

do this to run Hello World as .net CONSOLE app:

mkdir hwapp

cd hwapp

dotnet new

dotnet restore

dotnet run

if you got the same FW version on windows -- copy the project.dll and project.runtimeconfig.json file to Linux and run with dotnet project.dll!


### notes on debACOxx machine setup:

see readME_DEBACO_setup.txt

### check iptables with nmap fromsame or another host: this is the expected result:


sudo nmap 78.xx.xx.xx

PORT    STATE    SERVICE

22/tcp  open     ssh

111/tcp filtered rpcbind

