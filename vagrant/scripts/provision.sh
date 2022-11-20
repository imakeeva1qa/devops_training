#!/bin/bash

echo "--- adding user pub key ---"
my_ssh_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCjjqL8ugdH8t6P0LsxElasi8xaUoOhezdNGp9NoShtbJVoWTSSysdWCegE2w2znS2FtByEvhuwP8vA5pihnMXssYRf/G0sCcbw1XfqSeCBU5K6zCsgiP621Xgs6I1YvbQuVxEYqOmw/r0f0sEAmJVgY5ATwLi7kVNU5zExpJNilr/tUIjsNGxtzyEvAi0i5YX3y7pU422HHGwi53Z04TOM1Os//jaaFKgHzr+I5iAkStdfT7GzSv/25EE+DpygWKjhx2TUUImGwrD9vZwX85hL/bH9rFe/donQ0rDEoTeFJmEUHW2CUrwBp5U/BztxsU7QLrxN2NsBMNfr27FqbTFeKNXc6LF/p+yja1GZNVcNRn4o54UwcF9/ktW3Ik+JRSRybVDtfKnznk3iE5bkpZSUU0XbLaFE79JWTBaQH/EU7naYT1DqmjceM6ho5H8A8PlXiyjOQMtOTxmiAh5Q5aAxuwpuomk2Kw9x4pH0tbgry6rumUtdN67MDXwwNLqQDBs= user@Ramshtolce-Laptop"
echo "${my_ssh_key}" >> /home/vagrant/.ssh/authorized_keys
systemctl restart sshd.service

echo "--- changing app config ---"
sed -i -E 's/listen  80/listen  22080/' /etc/nginx/conf.d/test.site.conf
cat << EOF >> /etc/nginx/conf.d/test.site.conf
server {
  listen 80;

  server_name proxy;

  location / {
      proxy_pass http://127.0.0.1:22080;

      proxy_redirect off;
      proxy_http_version 1.1;
  }
}
EOF
cat /etc/nginx/conf.d/test.site.conf | grep listen
semanage port -a -t http_port_t  -p tcp 22080

echo "--- adding critical dependency ---"
yum install -y epel-release yum-utils
yum-config-manager --enable remi-php74
yum install -y php-gd

systemctl restart nginx && systemctl restart php-fpm

echo "--- adding permissions ---"
chcon -R -t httpd_sys_rw_content_t /var/www/html/test.site/
