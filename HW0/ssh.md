```shell script
sudo docker run -i --name ssh-test -d ubuntu
# Get IP address
docker inspect -f "{{ .NetworkSettings.IPAddress }}" ssh-test
# Get inside
docker exec -it ssh-test /bin/bash
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
##5
```
AllowUsers dnsl
```


