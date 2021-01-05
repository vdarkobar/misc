# Bastion
## Create Bastion Server
  
<p align="left">
  <a href="https://github.com/vdarkobar/Home_Lab#proxmox">Home</a>
</p>  
  
*Download <a href="https://www.debian.org/index.html">Debian Server</a> and create Proxmox VM: (1CPU/1GBRAM/8GBHDD).  
Add SSH Server. Dont set root password during installation (created user will have sudo privilages).*  
  
### Update, install packages and reboot:
```
sudo apt update && sudo apt upgrade -y && \
sudo apt install -y \
  ufw \
  fail2ban \
  qemu-guest-agent
```
```
sudo apt clean && sudo apt autoremove && sudo reboot
```
  
### SSH
```
sudo nano /etc/ssh/sshd_config
```	    
Add line at the end:
```
AllowUsers <username>					# adjust <username>
```
```
sudo systemctl restart ssh
```

### Fail2Ban
```
sudo systemctl status fail2ban
sudo fail2ban-client status
```
Config:
```
cd /etc/fail2ban
sudo cp jail.conf jail.local
sudo nano jail.local
```
Enabling jails (explicit rule), under jail name add:
```
enabled = true
```
```
sudo systemctl restart fail2ban
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
sudo ufw reload
sudo ufw status numbered
```      
Check Listening Ports:
```
netstat -tunlp
```
  
### Secure the server:
Secure Shared Memory:
```
sudo nano /etc/fstab
```
Copy paste the below text the very bottom of the file:
```
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
Test:
```
sudo sysctl -p
```
  
### Option to disable root account:
To disable, you can remove the password of the root account or lock it down, or even do both:  
  
Remove the root password:
```
sudo passwd -d root
```
Lock the account:
```
sudo passwd -l root
```
  
### Install google-authenticator for Debian/Ubuntu-based systems:
config file : ~/.google_authenticator
```
sudo apt-get install libpam-google-authenticator
google-authenticator -d -f -t -r 3 -R 30 -W
```
  
Output > # QR code + backup codes 
  
Edit the PAM configuration for the sshd service (/etc/pam.d/sshd), add:
```
sudo nano /etc/pam.d/sshd
```
```
auth required pam_google_authenticator.so nullok
```
Change the default auth so that SSH won’t prompt users for a password if they don’t present a 2-factor token (/etc/pam.d/sshd), comment out:
```
sudo nano /etc/pam.d/sshd
```
```
#@include common-auth
```	
Tell SSH to require the use of 2-factor auth. Edit the /etc/ssh/sshd_config file to allow the use of PAM for credentials, change:
```
sudo nano /etc/ssh/sshd_config
```
```
ChallengeResponseAuthentication yes
AuthenticationMethods keyboard-interactive					# add this line at the end of the file

#AuthenticationMethods publickey,keyboard-interactive				# if you are using pki
```
Restart sshd:
```
sudo systemctl restart sshd
```
Test logging in using Verification Code.
  
### Generate keys:
```
ssh-keygen -t ecdsa -b 521
```
Copy ID to desired VM:
```
ssh-copy-id -i ~/.ssh/id_ecdsa.pub user@ip
```
### Test: 
SSH to VM
```
ssh user@ip
```
