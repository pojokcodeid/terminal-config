```
sudo dnf install nginx
sudo dnf install php php-fpm

systemctl enable nginx
systemctl start nginx
systemctl status nginx 

systemctl enable php-fpm
systemctl start php-fpm
systemctl status php-fpm

sudo mkdir -p /var/www/example.com/html
sudo chown -R $USER:$USER /var/www/example.com/html

cd /etc/nginx/conf.d/
sudo nano example.com.conf

server {
    listen 80;
    listen [::]:80;

    server_name example.com www.example.com;

    root /var/www/example.com/html;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
		
		location ~ \.php$ {
    try_files $uri =404;
			fastcgi_pass unix:/run/php-fpm/www.sock;
			fastcgi_index index.php;
			fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			include fastcgi_params;
		}
}

sudo systemctl restart nginx php-fpm

-- Install MariaDB
	dnf install mariadb-server mariadb -y
	systemctl start mariadb
	systemctl enable mariadb
	systemctl status mariadb
	mysql_secure_installation
	
-- Update PHP Version
	sudo su
	dnf update
	dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
	dnf install https://rpms.remirepo.net/enterprise/remi-release-9.rpm
	dnf module list php
	dnf module install php:remi-8.2
	dnf update
	php -v
	
-- copy phpmyadmin
	cd /pojok_code/
	cp -r phpmyadmin*.zip /var/www/example.com/html/
	cd /var/www/example.com/html/
	unzip phpmyadmin*.zip 
	sudo rm phpmyadmin*.zip
	sudo mv phpmyadmin* phpmyadmin 
	
	coba bula dari browser
```
