```
sudo dnf upgrade --refresh
sudo dnf install http://rpms.remirepo.net/fedora/remi-release-37.rpm -y
dnf repolist | grep remi
dnf module list php
sudo dnf module enable php:remi-8.2 -y
sudo dnf install php-fpm php-cli php-common php-mysqlnd php-xml php-json php-gd php-mbstring -y
php -v

sudo dnf install nginx

systemctl enable nginx
systemctl start nginx
systemctl status nginx 

systemctl enable php-fpm
systemctl start php-fpm

sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

sudo mkdir -p /var/www/example.com/html
sudo chown -R $USER:$USER /var/www/example.com/html
sudo chmod -R 755 /var/www
sudo dnf install nano
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

-- copy phpmyadmin
	cd /pojok_code/
	cp -r phpmyadmin*.zip /var/www/example.com/html/
	cd /var/www/example.com/html/
	unzip phpmyadmin*.zip 
	sudo rm phpmyadmin*.zip
	sudo mv phpmyadmin* phpmyadmin 
	
	coba bula dari browser
```
