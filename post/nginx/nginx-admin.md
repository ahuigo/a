---
layout: page
title:	lemp环境搭建
category: blog
description: 
---
# Preface
本文描述的是centOS6下的[lemp]的配置过程.

# Install The Required Repositories

	sudo rpm -Uvh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
	sudo rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

# Step Two—Install MySQL
The next step is to begin installing the server software on the virtual private server, starting with MySQL and dependancies.
 sudo yum -y install mysql mysql-server

 Once the download is complete, restart MySQL:
 sudo /etc/init.d/mysqld restart

 You can do some configuration of MySQL with this command:
 sudo /usr/bin/mysql_secure_installation #password 1 root

# Step Three—Install nginx
As with MySQL, we will install nginx on our virtual private server using yum:

	sudo yum -y install nginx

nginx does not start on its own. To get nginx running, type:

	sudo /etc/init.d/nginx start

You can confirm that nginx has installed on your virtual private server by directing your browser to your IP address. You can run the following command to reveal your server’s IP address.

	ifconfig eth0 | grep inet | awk '{ print $2 }'

##　check service
	netstat -tanpl|grep nginx

## disable selinux if U want
	in file /etc/selinux/config
	SELINUX=disabled

## disable firewall
	service iptables stop
	service ip6tables stop
	chkconfig iptables off #when OS start

Task: Verify that firewall is disabled
Type the following command as root user to see IPv4 firewall rules:

	# /sbin/iptables -L -v -n
	OR
	# service iptables status

## log 
默认日志在:

	/var/log/nginx/


# Step Four—Install PHP
The php-fpm package is located within the REMI repository, which, at this point, is disabled. The first thing we need to do is enable the REMI repository and install php and php-fpm:

	sudo yum -y --enablerepo=remi install php php-fpm php-mysql
	sudo yum --enablerepo=remi,remi-php54 install php-devel

# Step Five—Configure php
We need to make one small change in the php configuration. Open up php.ini:

	 sudo vim /etc/php.ini

 Find the line, cgi.fix_pathinfo=1, and change the 1 to 0.

	 cgi.fix_pathinfo=0

 If this number is kept as a 1, the php interpreter will do its best to process the file that is as near to the requested file as possible. This is a possible security risk. If this number is set to 0, conversely, the interpreter will only process the exact file path—a much safer alternative. Save and Exit.

# Step Six—Configure nginx
Open up the default nginx config file:

	sudo vi /etc/nginx/nginx.conf

Raise the number of worker processes to 4 then save and exit that file. 

Now we should configure the nginx virtual hosts. In order to make the default nginx file more concise, the virtual host details are in a different location.


	sudo vim /etc/nginx/conf.d/default.conf

	server{
		listen       80 ;
		root /usr/share/nginx/hilo;
		server_name  server_name;
		server_name  hilo.com;


		rewrite  "^/(.*)" /index.php/$1 last;

		location  / {
				fastcgi_intercept_errors on;
				set $script_uri "";
				if ( $request_uri ~* "([^?]*)?" ) {
						set $script_uri $1;
				}

				fastcgi_pass 127.0.0.1:9000; #php-fpm
				fastcgi_param  SCRIPT_FILENAME  $document_root$fastcgi_script_name;
				include fastcgi_params;
		}
	}

	

## Open up the php-fpm configuration:

	sudo vim /etc/php-fpm.d/www.conf

Replace the apache in the user and group with nginx:

	[...]
	; Unix user/group of processes
	; Note: The user is mandatory. If the group is not set, the default user's group '
	;	will be used.
	; RPM: apache Choosed to be able to access some dir as httpd
	user = nginx
	; RPM: Keep a group allowed to write in log dir.
	group = nginx
	[...]

Finish by restarting php-fpm.

	sudo service php-fpm restart

# Step Seven—RESULTS: Create a php info page

Although LEMP is installed, we can still take a look and see the components online by creating a quick php info page

To set this up, first create a new file:

	sudo vi /usr/share/nginx/html/info.php

Add in the following line:

	<?php
	phpinfo();

Then Save and Exit. 

Restart nginx so that all of the changes take effect:

	sudo service nginx restart

# Step Eight—Set Up Autostart
You are almost done. The last step is to set all of the newly installed programs to automatically begin when the VPS boots.

	sudo chkconfig --levels 235 mysqld on
	sudo chkconfig --levels 235 nginx on
	sudo chkconfig --levels 235 php-fpm on

# reboot all service
	cat rebootLemp.sh
	sudo /etc/init.d/mysqld restart
	sudo /etc/init.d/nginx restart; #sudo service nginx restart
	sudo service php-fpm restart

## nginx -h

    nginx -s  stop|quit|reopen|reload

# install php
 brew install php54 --with-fpm  --with-homebrew-openssl --with-homebrew-curl

# 参考
[lemp]
[lemp介绍]

[lemp]: https://www.digitalocean.com/community/articles/how-to-install-linux-nginx-mysql-php-lemp-stack-on-centos-6
[lemp介绍]: http://ixdba.blog.51cto.com/2895551/806622
[mac lemp]: http://dhq.me/mac-install-nginx-mysql-php-fpm
