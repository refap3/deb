# deb
various patches 4 debian 8 etc.

new menu script for main functions

patch_xxx patches feature xxx
install_xxx install feature xxx

new: ssh with key only // and password

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

### check iptables with nmap from same or another host -- this is the expected result:


sudo nmap 78.xx.xx.xx

PORT    STATE    SERVICE

22/tcp  open     ssh

111/tcp filtered rpcbind


#----------------------------------------------

sudo apt update

sudo apt install git -y

git config --global credential.helper store

git config --global user.email "refap3@gmail.com"

git config --global user.name "lecc oreshheFROMap3"


#

mkdir deb

cd ~

git clone https://github.com/refap3/deb 

./deb/menu

#

There is a install_docker and a docker-compose.yaml file for ntopng, influxdb aand grafana (+ portainer)




