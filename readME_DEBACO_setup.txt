Do this to GENERATE safe DEBaco machine 
------------------------------------------

edit required IP ADDRESS
PUT VM in VLAN 2 
reboot check nslookup 

     nano /etc/network/interfaces
     reboot 
     ifconfig 
     nslookup hp.com 

install GIT 
Clone
Patch 3 

     apt-get install git -y
     git clone http://github.com/refap3/deb
     cd deb 
     ./patch_sudo 
     ./patch_iptables 
     ./patch_sshkeys 

might check with 

    apt-get update
    apt-get install nmap -y
