#!/bin/sh

DONE=/tmp/.init_base
if [ ! -f ${DONE} ]; then

    sudo yum -y install wget

    ##############################
    # Repository
    ##############################
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
    wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    sudo rpm -Uvh epel-release-6-8.noarch.rpm
    sudo rpm -Uvh remi-release-6.rpm
    sudo sed -i "6s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo



    ##############################
    # Apache
    ##############################
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
    sudo sed -i -e 's|#EnableMMAP off|EnableMMAP off|' /etc/httpd/conf/httpd.conf
    sudo sed -i -e 's|#EnableSendfile off|EnableSendfile off|' /etc/httpd/conf/httpd.conf

    # mod welcome.conf
    sudo sed -i -e "s|Options -Indexes|#Options -Indexes|" /etc/httpd/conf.d/welcome.conf
    sudo sed -i -e "s|ErrorDocument|#ErrorDocument|" /etc/httpd/conf.d/welcome.conf



    ##############################
    # PHP
    ##############################
    sudo yum install -y php php-devel php-mysql php-mbstring php-gd
    sudo sed -i "s/;error_log = syslog/error_log = \/var\/log\/php.log/g" /etc/php.ini
    sudo sed -i "s/;mbstring.language = Japanese/mbstring.language = Japanese/g" /etc/php.ini
    # sudo sed -i "s/;mbstring.internal_encoding = EUC-JP/mbstring.internal_encoding = UTF-8/g" /etc/php.ini
    # sudo sed -i "s/;mbstring.http_input = auto/mbstring.http_input = auto/g" /etc/php.ini
    sudo sed -i "s/;mbstring.detect_order = auto/mbstring.detect_order = auto/g" /etc/php.ini
    sudo sed -i "s/expose_php = On/expose_php = Off/g" /etc/php.ini
    sudo sed -i "s/;date.timezone =/date.timezone = Asia\/Tokyo/g" /etc/php.ini



    ##############################
    # MySQL
    ##############################
    sudo yum install -y --enablerepo=remi mysql-server
    # sudo vi /etc/my.cnf
    VAR="character_set_server=utf8\n\
    default-storage-engine=InnoDB\n\
    innodb_file_per_table\n\
    [mysql]\n\
    default-character-set=utf8\n\
    [mysqldump]\n\
    default-character-set=utf8\n\
    "
    sudo sed -i "4a $VAR" /etc/my.cnf



    ##############################
    # Start
    ##############################
    sudo service httpd restart
    sudo service mysqld start



    ##############################
    # MySQL secure install
    ##############################
    SQL="UPDATE mysql.user SET Password=PASSWORD('root') WHERE User='root';
    DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
    DROP DATABASE test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;"
    mysql -u root -e "$SQL"
    sudo chkconfig mysqld on



    ##############################
    # phpMyAdmin install
    ##############################
    # and php update...
    sudo yum --enablerepo=remi,epel,rpmforge,remi-php56 -y install phpMyAdmin php-mysql php-mcrypt
    sudo sed -i 's/Allow from 127.0.0.1/Allow from 192.168/g' /etc/httpd/conf.d/phpMyAdmin.conf


    sudo service httpd restart

    touch ${DONE}
fi
