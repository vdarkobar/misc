# Debian
## Proxmox Debian Template
  
<p align="left">
  <a href="https://github.com/vdarkobar/Home_Cloud#proxmox">Home</a>
</p>  
  
- Install Debian VM (2CPU/2GBRAM/10GBHDD), add SSH Server  
- Dont set root password during installation (created user will have sudo privilages)  
- For automatic disk resize to work create VM without SWAP Partition during install proces:

```
Partition disks > Manual > Continue
Select disk > SCSI3 QEMU HARDDISK > Continue
Create new empty Partition > Yes > Continue
New Partition Size > Continue
Primary > Continue
Bootable Flag > On > Done setting up the Partition > Continue
Finish partitioning and write changes to the disk > Continue
Return to the partitioning menu > No > Continue
Write changes to the disk > Yes > Continue
```
  
### Login to Bastion and copy ID to VM:
```
ssh-copy-id -i ~/.ssh/id_ecdsa.pub user@ip
```
Test: SSH to VM:
```
ssh user@ip
```
  
### Replace content od the: *~/.bashrc* file with this one: <a href="https://github.com/vdarkobar/shared/blob/main/.bashrc">.bashrc</a> then log out and log back in.
  
### Update and install packages: 
```
sudo apt update && \
sudo apt install -y \
  git \
  gpg \
  ufw \
  wget \
  curl \
  fail2ban \
  cloud-init \
  python3-pip \
  gnupg-agent \
  apache2-utils \
  bash-completion \
  fonts-powerline \
  ca-certificates \
  qemu-guest-agent \
  apt-transport-https \
  cloud-initramfs-growroot \
  software-properties-common
```
  
### Create swap file:
```
sudo -i
dd if=/dev/zero of=/swapfile bs=1024 count=1536000
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo "/swapfile       swap    swap    defaults        0 0" >> /etc/fstab
```
  
### Lockdown SSH:
```
sudo nano /etc/ssh/sshd_config
```
Change values to:
```
PermitRootLogin no
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no
```	
Add line at the end (adjust <username>):
```
AllowUsers <username>
```
```
sudo systemctl restart ssh
```
  
### Fail2Ban:
```
systemctl status fail2ban
sudo fail2ban-client status
```
Configuration:
```
cd /etc/fail2ban
sudo cp jail.conf jail.local
sudo nano jail.local
```
Enabling jails (explicit rule), under jail name add:
```
enabled = true
```
Change if needed:
```
[DEFAULT]
$ bantime =10m
$ findtime =10m
$ maxretry=5
```
```
sudo systemctl restart fail2ban
```
```
sudo fail2ban-client set sshd banip <ip>
sudo fail2ban-client set sshd unbanip <ip>
```
Check logs: 
```
sudo tail /var/log/auth.log
```
  
### UFW:
```
sudo ufw limit 22/tcp comment "SSH"
sudo ufw enable
```
Set defaults, Global blocks:
```
sudo ufw default deny incoming
sudo ufw default allow outgoing
```
```
sudo ufw reload
sudo ufw status numbered
```
Check Listening Ports
```
netstat -tunlp
```
  
### Secure the server:
Secure Shared Memory:
```
sudo nano /etc/fstab
# Copy paste next line, below the text at the very bottom of the file:

none /run/shm tmpfs defaults,ro 0 0
```
Edit file:
```
sudo nano /etc/sysctl.conf
```
Uncoment:
```
	##Spoof protection
net.ipv4.conf.def......
net.ipv4.conf.all......
	##ICMP redirects MITM attacks
net.ipv4.conf.all......
net.ipv6.conf.all......
	##send ICMP redirects not a router
net.ipv4.conf.all......
	##accept IP source route not a router
net.ipv4.conf.all......
net.ipv6.conf.all......
	##log Martians
net.ipv4.conf.all......
```
```
sudo sysctl -p
```
  
### Fix machine-id change:  
(*cloned VM to have different MAC addressws*)
```
cat /etc/machine-id
sudo rm /etc/machine-id
sudo touch /etc/machine-id
cat /var/lib/dbus/machine-id
sudo rm /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
ls -l /var/lib/dbus/machine-id
```
### Option to disable root account:
To disable, you can remove the password of the root account or lock it down, or even do both:
Remove the root password:             << use this one, lock the root account after cloning VM
```
sudo passwd -d root
```
Lock the account:
```
sudo passwd -l root
```
  
### Cloud-init:
```
sudo nano /etc/cloud/cloud.cfg
```
Remove (what you are not using):
```
# this can be used by upstart jobs for 'start on cloud-config'.
- snap
- snap_config  # DEPRECATED- Drop in version 18.2
- ubuntu-advantage
- disable-ec2-metadata
- byobu

#The modules that run in the 'final' stage
cloud_final_modules:
 - snappy  # DEPRECATED- Drop in version 18.2
 - fan
 - landscape
 - lxd
 - puppet
 - chef
 - mcollective
 - salt-minion
 - rightscale_userdata
```
  
Poweroff VM to convert to template:
```
sudo apt clean && sudo apt autoremove
sudo poweroff
```
  
#### Add cloud-init drive to VM: 
  
- *VM > Hardware > Add > Cloudinit drive*  
Add login data to Cloudinit drive  
VM > Cloudinit  
- *Add: username and password, public key*  
Click  
- *Regenerate Image*  
  
#### Convert VM to Template.  

<a href="https://github.com/vdarkobar/Home_Cloud#proxmox">top of the page</a>
