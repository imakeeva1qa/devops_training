#!/bin/bash

set -e

yum -y update

app_path="/var/www"

# Apache
yum install httpd -y
systemctl start httpd.service
systemctl enable httpd.service


# MySQL
wget http://repo.mysql.com/mysql57-community-release-el7.rpm
# yum install yum-utils -y
rpm -ivh mysql57-community-release-el7.rpm
yum -y update
rpm --import http://repo.mysql.com/RPM-GPG-KEY-mysql-2022
yum install mysql-server -y

systemctl start mysqld

password=$(grep -oP 'temporary password(.*): \K(\S+)' /var/log/mysqld.log)
new_password="admfoqiw88123@IQ"
mysqladmin --user=root --password=${password} password ${new_password}
# mysql --user=root --password=${new_password} -e "UNINSTALL COMPONENT 'file://component_validate_password';"
mysql --user=root --password=${new_password} -e "UNINSTALL PLUGIN validate_password;"
mysqladmin --user=root --password=${new_password} password ""

mysql < /tmp/db.sql    # TODO create a file or Import
rm /tmp/db.sql

# PHP
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
yum makecache
yum -y install yum-utils
yum-config-manager --disable 'remi-php*'
amazon-linux-extras enable php8.0
yum clean metadata
yum install -y php-{pear,cgi,pdo,common,curl,mbstring,gd,mysqlnd,gettext,bcmath,json,xml,fpm,intl,zip}

# nodeJS
curl -sL https://rpm.nodesource.com/setup_18.x | sudo bash -
yum install nodejs -y
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
nvm install 16
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
npm install -g gatsby-cli 1.1.41-13
# npm install -g gatsby-cli
# npm install gatsby@next --legacy-peer-deps

# Wordpress
curl -O --output-dir /tmp https://wordpress.org/latest.tar.gz
tar xavf /tmp/latest.tar.gz -C ${app_path}
rm -f /tmp/latest.tar.gz -v

systemctl restart httpd.service && systemctl restart php-fpm


####################
# config wordpress #
####################

chown -R apache:apache ${app_path}/wordpress
find ${app_path}/wordpress/ -type d -exec chmod 750 {} \;
find ${app_path}/wordpress/ -type f -exec chmod 640 {} \;

mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
mv /tmp/wordpress.conf /etc/httpd/sites-available/wordpress.conf    # TODO create a file or Import
cp /tmp/wp-config.php ${app_path}/wordpress/wp-config.php           # TODO create a file or Import

ln -s /etc/httpd/sites-available/wordpress.conf /etc/httpd/sites-enabled/wordpress.conf

setsebool -P httpd_unified 1

systemctl restart httpd.service && systemctl restart php-fpm


###################
#  config gatsby  #
###################


