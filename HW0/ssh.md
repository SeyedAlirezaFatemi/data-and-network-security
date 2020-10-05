```shell script
sudo docker run -p 52022:22 -i --name ssh-test -d ubuntu
# Get IP address
docker inspect -f "{{ .NetworkSettings.IPAddress }}" ssh-test
# Get inside
docker exec -it ssh-test /bin/bash
sudo ufw enable
sudo ufw allow from any to any port 52022 proto tcp
sudo ufw delete allow from any to any port 52022 proto tcp
sudo ufw status verbose
hostname -I
```
```shell script
apt update
apt install ssh
service ssh restart 
service ssh status
passwd root
adduser dnsl
apt install nano
```
After changing "/etc/ssh/sshd_config" run:
```shell script
service ssh restart
```
For each part add the mentioned lines to "/etc/ssh/sshd_config":
## 1
```
PermitRootLogin no
```
## 2
```
ClientAliveInterval 60
ClientAliveCountMax 0
```
## 3
```
ChallengeResponseAuthentication no
PasswordAuthentication no
UsePAM no
```
## 4
```
Port 2062
```
## 5
```
AllowUsers dnsl
```
##6
Resources:
+ https://linuxconfig.org/how-to-change-welcome-message-motd-on-ubuntu-18-04-server
+ https://www.tecmint.com/protect-ssh-logins-with-ssh-motd-banner-messages/

To change the message after login change the content of "/etc/motd" and the files in "/etc/update-motd.d/".

To change the message before login change the content of "/etc/issue.net".
```
# For message befor login
Banner /etc/issue.net
# Optional
# Disable after login banners
chmod -x /etc/update-motd.d/*
PrintLastLog no
```
##7
Resources:
+ https://hackertarget.com/ssh-two-factor-google-authenticator/
```shell script
apt install libpam-google-authenticator
google-authenticator
```
```
ChallengeResponseAuthentication yes
UsePAM yes
```
