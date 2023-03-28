## Config Supaya Centos Bisa Copy Paste
```
sudo su 
yum -y install epel-release
yum -y update
yum install make gcc kernel-headers kernel-devel perl dkms bzip2
export KERN_DIR=/usr/src/kernels/$(uname -r)
mount -r /dev/cdrom /media
cd /media/
./VBoxLinuxAdditions.run
power off and enable share clipboard
power off and enable share clipboard
```

## Config PHP, Apache dan MariaDB
```
-- install apache
	sudo su
	dnf update
	dnf install httpd httpd-tools
	systemctl enable httpd
	systemctl start httpd
	systemctl status httpd
	firewall-cmd --permanent --zone=public --add-service=http
	firewall-cmd --permanent --zone=public --add-service=https
	firewall-cmd --reload
	
	ip a 
	
	lakuakn cek degan measukan op dari browser 
	
-- Install MariaDB
	dnf install mariadb-server mariadb -y
	systemctl start mariadb
	systemctl enable mariadb
	systemctl status mariadb
	mysql_secure_installation
	
-- Install PHP 
	yum install php php-mysqlnd php-pdo php-gd php-mbstring
	systemctl restart httpd 
	echo "<?php phpinfo() ?>" > /var/www/html/info.php
	
	bukan ipadress/info.php

-- Update PHP Version
	sudo su
	dnf update
	dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
	dnf install https://rpms.remirepo.net/enterprise/remi-release-9.rpm
	dnf module list php
	dnf module install php:remi-8.2
	dnf update
	php -v
	
-- setting virtual host 
	sudo mkdir -p /var/www/example.com/html
	sudo mkdir -p /var/www/example.com/log
	sudo chown -R $USER:$USER /var/www/example.com/html
	sudo chmod -R 755 /var/www
	sudo vi /var/www/example.com/html/index.html
	
	<html>
		<head>
			<title>Welcome to Example.com!</title>
		</head>
		<body>
			<h1>Success! The example.com virtual host is working!</h1>
		</body>
	</html>

	sudo mkdir /etc/httpd/sites-available /etc/httpd/sites-enabled
	sudo vi /etc/httpd/conf/httpd.conf
	
	tekan shift + g --> untuk membuat cursor ke akhir page
	-- tambahkan ini di bagian paling bawah 
	IncludeOptional sites-enabled/*.conf
	escape :wq 
	
	sudo vi /etc/httpd/sites-available/example.com.conf
	<VirtualHost *:80>
           ServerName www.example.com
           ServerAlias example.com
           DocumentRoot /var/www/example.com/html
           ErrorLog /var/www/example.com/log/error.log
           CustomLog /var/www/example.com/log/requests.log combined
	</VirtualHost>
	
	sudo ln -s /etc/httpd/sites-available/example.com.conf /etc/httpd/sites-enabled/example.com.conf
	
	sudo setsebool -P httpd_unified 1
	sudo ls -dlZ /var/www/example.com/log/
	
	sudo semanage fcontext -a -t httpd_log_t "/var/www/example.com/log(/.*)?"
	sudo restorecon -R -v /var/www/example.com/log
	
	sudo ls -dlZ /var/www/example.com/log/
	
	sudo systemctl restart httpd
	ls -lZ /var/www/example.com/log
	
	coba lagi load ipadress/ dari browser 
	
-- coba tambah file php 
	cd /var/www/example.com/html/ 
	sudo mv index.html index_backup.html
	sudo vim index.php 
	
	<?php 
	phpinfo();
	
	save dan coba lagi dari browser
	
-- copy phpmyadmin
	cd /pojok_code/
	cp -r phpmyadmin*.zip /var/www/example.com/html/
	cd /var/www/example.com/html/
	unzip phpmyadmin*.zip 
	sudo rm phpmyadmin*.zip
	sudo mv phpmyadmin* phpmyadmin 
	
	coba bula dari browser
	
-- Update PHP
	sudo dnf upgrade --refresh
	sudo dnf install http://rpms.remirepo.net/fedora/remi-release-37.rpm -y
	dnf repolist | grep remi
	dnf module list php
	sudo dnf remove php php-cli -y
	sudo dnf module enable php:remi-8.2 -y
	sudo dnf install php php-cli php-common php-mysqlnd php-xml php-json php-gd php-mbstring -y
	sudo systemctl start httpd 
```
