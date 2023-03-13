#!/bin/bash
sudo apt update -y
#installinging Nginx and starting
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
#installing docker
sudo apt install docker.io -y
sudo usermod -aG docker $USER
#installing git
sudo apt install git -y
#git clone
git clone https://github.com/LondheShubham153/django-notes-app.git && cd django-notes-app
#building docker image via dockerfile
sudo docker build -t notes-app .
#creating the containg
docker run -d -p 8000:8000 notes-app:latest
#coping the proxy file to nginx configd
sudo cp /tmp/proxy /etc/nginx/sites-available/
cd /etc/nginx/sites-available/
#craeting a softlink 
sudo ln -s /etc/nginx/sites-available/proxy /etc/nginx/sites-enabled/
#restarting nginx
sudo systemctl restart nginx 