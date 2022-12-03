sudo apt-get update && sudo apt-get upgrade -y && 
sudo apt install git terminator openssh-server htop lvm2  gparted -y

sudo rm /etc/ssh/ssh_hosts_*
sudo truncate -s 0 /etc/machine-id

sudo apt clean
sudo apt autoremove

# optional
sudo apt install docker.io -y
sudo systemctl enable --now docker
sudo usermod -aG docker $USER


# Do this if there is ssh problem after copying the template:
# sudo ssh-keygen -A
# sudo systemctl restart ssh