#!/bin/sh

DONE=/tmp/.init_base
if [ ! -f ${DONE} ]; then

    # install httpd
    sudo yum -y install httpd
    sudo service httpd start
    sudo chkconfig httpd on

    # iptables off
    sudo service iptables stop
    sudo chkconfig iptables off

    # create documentRoot
    # -> create auto by Vagrantfile...
    # sudo mkdir -v /var/www/html/public_html
    # sudo chown vagrant /var/www/html/ -R

    # mod httpd.conf
    cp -p /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd.conf.orig
    sudo sed -i -e "s|ServerTokens OS|ServerTokens Prod|" /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s|KeepAlive Off|KeepAlive On|" /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s|Options Indexes FollowSymLinks|Options FollowSymLinks|" /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s|DirectoryIndex index.html index.html.var|DirectoryIndex index.html index.php|" /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s|ServerSignature On|ServerSignature Off|" /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s|AddDefaultCharset UTF-8|#AddDefaultCharset UTF-8|" /etc/httpd/conf/httpd.conf
    sudo sed -i -e "s|AllowOverride None|AllowOverride All|" /etc/httpd/conf/httpd.conf
    sudo sed -i -e 's|DocumentRoot "/var/www/html"|DocumentRoot "/var/www/html/public_html"|' /etc/httpd/conf/httpd.conf
    sudo sed -i -e 's|<Directory "/var/www/html">|<Directory "/var/www/html/public_html">|' /etc/httpd/conf/httpd.conf
    sudo sed -i -e 's|#EnableSendfile off|EnableSendfile off|' /etc/httpd/conf/httpd.conf

    # mod welcome.conf
    sudo sed -i -e "s|Options -Indexes|#Options -Indexes|" /etc/httpd/conf.d/welcome.conf
    sudo sed -i -e "s|ErrorDocument|#ErrorDocument|" /etc/httpd/conf.d/welcome.conf

    sudo service httpd restart

    # install etc...
    sudo yum install -y nodejs
    sudo yum install -y npm
    sudo npm install -g gulp

    sudo yum install -y ruby
    sudo yum install -y ruby-devel
    sudo yum install -y rubygems
    sudo gem install sass
    sudo gem install compass

    touch ${DONE}
fi

