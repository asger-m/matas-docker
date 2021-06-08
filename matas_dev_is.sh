#build ubuntu_ssh template: docker build -t ubuntu_ssh

docker run -d --name dev-is --network is.matas.dk \
  --ip 172.19.0.3 ubuntu_ssh

#ssh to containers: ssh root@ip_address
#add ip and hostnames to /etc/hosts
sudo gedit /etc/hosts
sshpass -p root ssh root@dev.is.matas.dk



docker run -d -p 9443:9443 --name dev-is --network is.matas.dk \
  --ip 172.19.0.3 ubuntu_ssh


