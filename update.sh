sudo apt update
sudo apt upgrade -y
sudo apt install mariadb-server -y
myql --user=root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('${ZAQ!2wsx}') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
GRANT ALL PRIVILEGES ON *.* TO 'ADMIN'@'%' IDENTIFIED BY 'ZAQ!2wsx' WITH GRANT OPTION;
FLUSH PRIVILEGES;
_EOF_
sudo service --status-all
