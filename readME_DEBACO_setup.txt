    1  ifconfig 
    2  sssshutdown 
    3  shutdown -h now
    4  nano /etc/network/interfaces
    5  reboot 
    6  ifconfig 
    7  nano /etc/network/interfaces
    8  ifdown eth0
    9  reboot
   10  ifconfig 
   11  ping 8.8.8.8
   12  nslookup hp.com 
   13  nslookup hp.com  8.8.8.8.
   14  nslookup hp.com 8.8.8.8
   15  nslookup dec.com 
   16  nano /etc/initramfs-tools/modules 
   17  update-initramfs 
   18  update-initramfs  -u
   19  reboot
   20  lsmod
   21  nano /etc/network/interfaces
   22  cat /etc/network/interfaces
   23  cd /etc
   24  ls sud*
   25  ls
   26    
   27  nano resolv
   28  clear
   29  nano resolv.conf 
   30  cat resolv.conf 
   31  id debian8
   32  groups
   33  groups debian8
   34  usermod  -a -G root debian8 
   35  id debian8 
   36  nano /etc/network/interfaces
   37  reboot
   38  ifconfig
   39  nslookup hp.com
   40  apt-get install git -y
   41  git clone http://github.com/refap3/deb
   42  cd deb 
   43  ls
   44  ./patch_sudo 
   45  ./patch_iptables 
   46  ./patch_sshkeys 
   47  history>aa.txt
