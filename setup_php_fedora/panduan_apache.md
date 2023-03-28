# Config Virtualbox
```
sudo su 
sudo dnf install kernel-devel kernel-headers make gcc perl 
export KERN_DIR=/usr/src/kernels/$(uname -r)
mount -r /dev/cdrom /media
cd /media/
./VBoxLinuxAdditions.run
power off and enable share clipboard

dnf groupinstall "Cinnamon Desktop"
systemctl set-default graphical.target
reboot
```

# Config PHP Apache dan MariaDB
```
sudo dnf update
dnf install httpd httpd-tools
sudo systemctl start httpd 
sudo systemctl enable httpd 
sudo systemctl status httpd

sudo dnf install mariadb-server 
sudo systemctl enable mariadb 
sudo systemctl start mariadb 
sudo mysql_secure_installation 
sudo systemctl status mariadb 

sudo dnf install php php-common php-mysqlnd 
sudo dnf install php-xml php-json php-gd php-mbstring 
php -v 

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

sudo systemctl restart httpd 
sudo dnf install nano
sudo nano /var/www/html/info.php

<?php
  phpinfo();
?>

nmcli -p device show

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
