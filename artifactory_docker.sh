#setup an artifactory inside docker
#Based from https://www.coachdevops.com/2020/11/setup-jfrog-artifactory-on-ubuntu-1804.html

#1 Pull docker image
docker pull docker.bintray.io/jfrog/artifactory-oss:latest

#2 make a folder to be mounted later to docker image
#This folder will contain the artifacts of CI
mkdir -p ~/dev/jfrog/artifactory
sudo chown -R 1030 ~/dev/jfrog/
chmod g+w ~/dev/jfrog/ && chmod g+w ~/dev/jfrog/artifactory

#3 Start image, -d means keep running in the background. Attach later
#Port 8081 for Artifactory REST APIs.
#Port 8082 for everything else (UI, and all other product’s APIs). 
sudo docker run --name artifactory -d -p 8081:8081 -p 8082:8082 \
-v ~/dev/jfrog/artifactory:/var/opt/jfrog/artifactory \
docker.bintray.io/jfrog/artifactory-oss:latest

#4 Artifactory is now ready at
http://localhost:8082/
#default username/password is "admin" and "password"
#on first login, change the password to "Admin0x1"

#5 Optional
# Run artifactory as a service.
#Inside the host PC,
code  /etc/systemd/system/artifactory.service
#copy the following
[Unit]
Description=Setup Systemd script for Artifactory Container
After=network.target

[Service]
Restart=always
ExecStartPre=-/usr/bin/docker kill artifactory
ExecStartPre=-/usr/bin/docker rm artifactory
ExecStart=/usr/bin/docker run --name artifactory -p 8081:8081 -p 8082:8082 \
  -v /dev/jfrog/artifactory:/var/opt/jfrog/artifactory \
  docker.bintray.io/jfrog/artifactory-oss:latest
ExecStop=-/usr/bin/docker kill artifactory
ExecStop=-/usr/bin/docker rm artifactory

[Install]
WantedBy=multi-user.target 

#reload systemd
sudo systemctl daemon-reload

#Start artifactory container with systemd
sudo systemctl start artifactory

#Enable to start at system boot
sudo systemctl enable artifactory

#Check if service is running
sudo systemctl status artifactory