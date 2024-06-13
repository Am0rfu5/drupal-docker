#! /bin/bash

XDEBUG_INI=/etc/php/7.1/mods-available/xdebug.ini

if [ "$1" == "stop" ] || [ "$1" == "-s" ]; then
        sed -i 's/^zend_extension/;zend_extension/g' $XDEBUG_INI;
        systemctl restart php7.1-fpm;
        echo "xdebug stopped";
elif [ "$1" == "start" ] || [ "$1" == "-d" ]; then
        sed -i 's/^;zend_extension/zend_extension/g' $XDEBUG_INI;
        systemctl restart php7.1-fpm;
        echo "xdebug started";
elif [ "$1" == "status" ] || [ "$1" == "-n" ]; then
       if  grep -q ";zend_extension" $XDEBUG_INI; then
               echo "xdebug is stopped";
       else
               echo "xdebug is started";
       fi
elif [ -z "$1" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
        echo "usage:  xdebug [OPTION]";
        echo "options:";
        echo "          -d start";
        echo "          -s stop";
        echo "          -n status";
        echo "          -h help";
fi

# Dependency: 
# CentOS 7 or higher, Ubuntu 16.04 or higher (both run systemd)
# php-fpm
#
# installation:
# copy the script into a file named "xdebug"
# change the permission for file to allow execution: chmod 770 xdebug
# (you may need to change the path of your xdebug.ini file)
# 
# For ease of use you may want to add aliases to your .bashrc. 
# For example:
# alias xd='xdebug start'
# alias xs='xdebug stop'
# alias xn='xdebug status'
