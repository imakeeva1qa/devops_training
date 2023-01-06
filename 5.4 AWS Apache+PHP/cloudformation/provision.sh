#!/bin/bash

set -e
yum -y update
yum -y install git


# get configs
app_path="/var/www"
wget https://raw.githubusercontent.com/imakeeva1qa/devops_training/main/5.4%20AWS%20Apache%2BPHP/config/wp-config.php -P /tmp/
wget https://raw.githubusercontent.com/imakeeva1qa/devops_training/main/5.4%20AWS%20Apache%2BPHP/config/wordpress.conf -P /tmp/
wget https://raw.githubusercontent.com/imakeeva1qa/devops_training/main/5.4%20AWS%20Apache%2BPHP/cloudformation/db.sql -P /tmp/


# Apache
yum install httpd -y
systemctl start httpd.service
systemctl enable httpd.service


# MySQL
wget http://repo.mysql.com/mysql57-community-release-el7.rpm
rpm -ivh mysql57-community-release-el7.rpm
rpm --import http://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum -y update
yum install mysql-server -y

systemctl start mysqld

password=$(grep -oP 'temporary password(.*): \K(\S+)' /var/log/mysqld.log)
new_password="admfoqiw88123@IQ"
mysqladmin --user=root --password=${password} password ${new_password}
# mysql --user=root --password=${new_password} -e "UNINSTALL COMPONENT 'file://component_validate_password';"
mysql --user=root --password=${new_password} -e "UNINSTALL PLUGIN validate_password;"
mysqladmin --user=root --password=${new_password} password ""

mysql < /tmp/db.sql


# PHP
yum -y update
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum makecache
yum -y install yum-utils
yum-config-manager --disable 'remi-php*'
amazon-linux-extras enable php8.0
yum clean metadata
yum install -y php-{pear,cgi,pdo,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip}


# nodeJS + Gatsby
yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_16.x | bash -
yum install -y nodejs

npm -g i gatsby-cli@4.25.0
# npm audit fix --force 2>/dev/null

# for amazon linux 2022+:
#curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
#. ~/.nvm/nvm.sh
#nvm install --lts
#npm install -g npm@9.2.0    # update npm version, could be replaced
#npm install -g gatsby-cli
# gatsby --version


# Wordpress
curl -O --output-dir /tmp https://wordpress.org/latest.tar.gz
tar xavf /tmp/latest.tar.gz -C ${app_path}
rm -f /tmp/latest.tar.gz -v

systemctl restart httpd.service && systemctl restart php-fpm


####################
# configuring ######
# wordpress config #
mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
mv /tmp/wordpress.conf /etc/httpd/sites-available/wordpress.conf
cp /tmp/wp-config.php ${app_path}/wordpress/wp-config.php

chown -R apache:apache ${app_path}/wordpress
find ${app_path}/wordpress/ -type d -exec chmod 750 {} \;
find ${app_path}/wordpress/ -type f -exec chmod 640 {} \;

ln -s /etc/httpd/sites-available/wordpress.conf /etc/httpd/sites-enabled/wordpress.conf

# setsebool -P httpd_unified 1
systemctl restart httpd.service && systemctl restart php-fpm


# Gatsby config
gatsby new my-hello-world-starter https://github.com/gatsbyjs/gatsby-starter-hello-world
cd my-hello-world-starter/
gatsby build
gatsby serve --host 0.0.0.0 &
