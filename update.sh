sudo apt update
sudo apt upgrade -y
sudo apt install mariadb-server -y
sudo mysql -u root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('ZAQ!2wsx') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
GRANT ALL PRIVILEGES ON *.* TO 'ADMIN'@'%' IDENTIFIED BY 'ZAQ!2wsx' WITH GRANT OPTION;
create database wagodb;
FLUSH PRIVILEGES;
_EOF_
wget https://raw.githubusercontent.com/Michal9817/supreme-pancake/main/wagodb.sql


sudo apt install php-mysql -y
sudo apt install phpmyadmin -y
sudo service --status-all
echo 'koniec instalacji'
