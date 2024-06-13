# Notes

These are notes about various aspects in setting up a performant Drupal environment.They
do not all apply to the current project but are included for reference. They remain need
be reviewed as they may be outdated or apply to different operating systems.

## Overview of Development Environment

- Dockerfile(s)
    - php-8.3 build
        - local user
    - mysql-8
        - expose backup directory
- docker-compose
    - lamp stack
        - php
        - mysql
        - apache
- .env file
vim- git repos
    - main project containing docker files & drupal git submodule
    - drupal repo
        - In Composer
            - custom theme repo
            - custom module repos
        - site/default/settings.php
- site/default/files
    - local version that acts like a S3 bucket?
    - this can also be a docker volume via the docker-compose file
    - this is configurable in the settings.php file

## Overview of Production Environment
- install script
    - cli switch to trigger build of php container.3

##

## Local Development Setup for  Existing Project
Step 1:   `git clone --recurse-submodules <docker-project-main>`
Step 2:   `cd <docker-project-main>`
Step 3:   `cp .env.example .env`
Step 4:   configure .env file
Step 5:   `docker-compose up -d --build`
Step 6:   `docker-compose exec php bash` && `composer install` & `exit`
Step 7:   cp settings file to sites/default/settings.php
Step 8:   Restore MySQL Database
Step 9:   Files directory setup (Public, Private, Tmp,)


## Steps for to pull new updates

## Config docker-compose.yml

## config Dockerfile for php-8.3

## config .env file

## setup time sync on debian

## Permissions
! Note that the locations are changed in settings.php
chown -R hostuser:www-data /opt/drupal/web 
chmod -R 750 /opt/drupal/web
chmod -R 640 /opt/drupal/web/*.*
chown -R www-data:hostuser /opt/drupal/web/sites/default/files
chown -R www-data:hostuser /sites/default/private
# chown -R www-data:<site-user> sites/default/tmp
chmod -R 770 sites/default/files
chmod -R 770 sites/default/private


## settings.php file creation

## Database name during install
Database server is the container name
```
docker ps
```

Everything else is in .env

## Drush install 
composer require drush/drush

## sites/default/settings.php permissions changed post install

## Drupal site name, email, Admin user, password 

## service apache2 start, stop, restart 

The following commands are used to start, stop, and restart the Apache service in Linux.

```
sudo service apache2 start
sudo service apache2 stop
sudo service apache2 restart
```

## Custom parts in Git, use Composer to load them

######################
## FPM, APC & Memecache?

#################APC#####################
# basic configuration
vim /etc/php.d/apc.ini
extension=/usr/lib64/php/modules/apc.so
apc.enabled=1
apc.ttl=72000
apc.user_ttl=72000
apc.gc_ttl=3600
apc.shm_size=512M
apc.stat=1
apc.enable_cli=1
apc.file_update_protection=2
apc.max_file_size=1M
apc.num_files_hint=200000
apc.user_entries_hint=20000

#  to display apc.php results page
cd /var/tmp
curl -O https://pecl.php.net/get/APC
tar xvzf APC
cp APC<version>/apc.php <docroot>

################MYSQL################
# start & enable
systemctl start,enable mariadb

# unblock from firewall (optional)
firewall-cmd --add-service=mysql

# delete the anonymous users and the test databse

# secure MariaDB
/usr/bin/mysql_secure_installation

# Create a restricted user for databases with the following permissions
# delete the anonymous user for cli access by new user

# configure MySQL open_file_limits (now done with systemd)
mkdir /etc/systemd/system/mariadb.service.d
vim /etc/systemd/system/mariadb.service.d/limits.conf
[Service]
LimitNOFILE=65535
LimitMEMLOCK=65535

vim /etc/security/limits.conf
mysql            hard    nofile          65535
mysql            soft    nofile          65535

systemctl daemon-reload
systemctl restart mariadb

# my.cnf is no longer used directly but rather my.cnf.d/server.cnf my.cnf.d/client
# download and use mysqltuner for quick setup suggestions.  http://mysqltuner.com/
# a basic configuration is as follows

########### MEMCACHE
pecl install memcache

https://www.webfoobar.com/node/32

###############XDEBUG#################
# configure with "remote-xdebug" as idekey

##  WORKING
zend_extension=xdebug.so
xdebug.remote_enable=1
xdebug.remote_port=9002
xdebug.remote_host=127.0.0.1
xdebug.idekey=PHPSTORM

## CENTOS
cat > /etc/php.d/xdebug.ini <<EOF
zend_extension="/usr/lib64/php/modules/xdebug.so"
xdebug.remote_connect_back=1
xdebug.remote_port=9001
xdebug.profiler_enable=1
xdebug.idekey="remote-xdebug"
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
xdebug.remote_log="/var/log/xdebug.log"
xdebug.remote_mode=req
EOF

chmod +x /usr/lib64/php/modules/xdebug.so

###################xhprof###############
yum install -y graphviz \
xhprof

# create a vhost for the web interface

# change to the directory for vhosts
cd /var/www/html

#clone the repo for the web interface
git clone git://github.com/preinheimer/xhprof.git
cp 

##### webgrind
##### kcachegrind

#####Varnish startup (requires epel)
#systemctl enable varnish
#systemctl start varnish
#systemctl status varnish
#varnishd -V
# Configure Varnish

#### Solr
https://www.cocking.com/2015/03/30/apache-solr-5-0-install-on-centos-7/

##### Selenium test setup

#### phpunit

######Composer (NOTE: If Xdebug has already been enabled it will cause composer to give a warning that 
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# XDebug causes performance issues with composer but since we are actually only using xdebug 
# on demand it shouldn’t be a problem.  There are several workarounds including turning off the warning
# and configuring the php-cli to use xdebug directly using aliasing
# this can also be done for drush but xdebug is actually configured to run remotely only on command
# so it shouldn’t really be an issue.  Best to just remove the warning
# !!!!Doesn't this need to be changed permanently
COMPOSER_DISABLE_XDEBUG_WARN=1