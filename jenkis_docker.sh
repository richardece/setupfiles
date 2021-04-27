# Docker from https://hub.docker.com/r/jenkins/jenkins
# - d, detached
# port 8080, jenkins will use
# port 50000 for jenkins slave
# -v bind a named volume for persistency

docker run -p 8080:8080 -p 50000:50000 -d -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

# Access from localhost:8080
# get initial password from docker logs <container ID>

#username = admin
#password = Admin0x1

