#!/bin/bash

apt update

# nginx
apt install nginx -y

private_ip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`


cat << EOF > /var/www/html/index.nginx-debian.html
<html>
  <h2>Hello <font color="magenta">AWS</font>!</h2>
  <br>
    Private_ip: $private_ip
  <p>
</html>
EOF

cat << EOF > /etc/nginx/sites-enabled/example
server {
       listen 80;
       listen [::]:80;

       server_name example.ubuntu.com;

       root /var/www/html;
       index index.nginx-debian.html;

       location / {
               try_files $uri $uri/ =404;
       }
}
EOF

service nginx restart


# AWS CLI
apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
