echo 'Aktualizacja systemu'
sudo apt update
sudo apt upgrade -y
echo 'OK'


echo 'Instalacja mysql-server'
sudo apt install mariadb-server -y
echo 'OK'


#zmiana hasla roota, stworzenie konta admina i bazy wagodb
echo 'Konfiguracja mysql'
sudo mysql -u root <<_EOF_
UPDATE mysql.user SET Password=PASSWORD('ZAQ!2wsx') WHERE User='root';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
GRANT ALL PRIVILEGES ON *.* TO 'ADMIN'@'%' IDENTIFIED BY 'ZAQ!2wsx' WITH GRANT OPTION;
create database wagodb;
FLUSH PRIVILEGES;
_EOF_
echo 'OK'
#----------------------------------------------------------


echo 'Instalacja PHP i PHPmyAdmin'
sudo apt install php-mysql -y
sudo apt install phpmyadmin -y


#pobranie i zamiana konfigow do phpmyadmin i php

wget https://raw.githubusercontent.com/Michal9817/supreme-pancake/main/plugin_interface.lib.php
sudo rm /usr/share/phpmyadmin/libraries/plugin_interface.lib.php
sudo cp /home/pi/plugin_interface.lib.php /usr/share/phpmyadmin/libraries
echo 'OK'

echo 'instalacja konfiguracji php'
wget https://raw.githubusercontent.com/Michal9817/supreme-pancake/main/sql.lib.php
sudo rm /usr/share/phpmyadmin/libraries/sql.lib.php
sudo cp /home/pi/sql.lib.php /usr/share/phpmyadmin/libraries
echo 'OK'

echo 'restart mysql i phpmyadmin'
sudo service apache2 restart
sudo service mysqld restart
echo 'OK'
#-------------------------------------


#pobranie i import bazy
echo 'Pobieranie bazy wagodb'
wget https://raw.githubusercontent.com/Michal9817/supreme-pancake/main/wagodb.sql
sudo mysql -u root wagodb < wagodb.sql
echo 'OK'
#-----------------------


echo 'Instalacja NodeRED'
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)
sudo systemctl enable nodered.service
echo 'OK'


#konfiguracja pythona

echo 'Tworzenie sciezek'
sudo mkdir /var/www/html/udostepnione
sudo mkdir -p /home/pi/Documents/RAPORTY
echo 'OK'

echo 'Pobieranie programu'
wget https://github.com/Michal9817/supreme-pancake/blob/main/RaportGenerator.py
sudo cp /home/pi/RaportGenerator.py /home/pi/Documents
echo 'OK'

echo 'Instalownie bibliotek'
sudo apt install python3-pip
sudo pip3 install SQLAlchemy
sudo pip3 install numpy
sudo pip3 install pandas
sudo apt install libatlas-base-dev
sudo pip3 install pdfkit
sudo apt install wkhtmltopdf
sudo pip3 install datetime

WKHTML2PDF_VERSION='0.12.4'
sudo apt install -y openssl build-essential xorg libssl-dev
wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.raspberrypi.buster_armhf.deb
sudo dpkg -i wkhtmltox_0.12.6-1.raspberrypi.buster_armhf.deb
sudo apt-get -f install
echo 'exec xvfb-run -a -s "-screen 0 640x480x16" wkhtmltopdf "$@"' | sudo tee /usr/local/bin/wkhtmltopdf.sh >/dev/null
sudo chmod a+x /usr/local/bin/wkhtmltopdf.sh
echo 'OK'

#--------------------


#konfiguracja stalego adresu IP
wget https://raw.githubusercontent.com/Michal9817/supreme-pancake/main/wpa_supplicant.conf
sudo rm /etc/wpa_supplicant/wpa_supplicant.conf
sudo cp /home/pi/wpa_supplicant.conf /etc/wpa_supplicant/
#------------------------------


#konfigi mysql
wget https://raw.githubusercontent.com/Michal9817/supreme-pancake/main/50-server.cnf
sudo rm /etc/mysql/mariadb.conf.d/50-server.cnf
sudo cp /home/pi/50-server.cnf /etc/mysql/mariadb.conf.d/

wget https://raw.githubusercontent.com/Michal9817/supreme-pancake/main/my.cnf
sudo rm /etc/mysql/my.cnf
sudo cp /home/pi/my.cnf /etc/mysql/

echo 'restart mysql i phpmyadmin'
sudo service apache2 restart
sudo service mysqld restart
echo 'OK'
#-------------





echo 'Instalacja zakonczona'
echo 'Restart systemu za 20 sekund'
echo 'Aby anulowac wcisnij Ctrl+C'
sleep 17
echo 'Restart systemu za 3'
sleep 1
echo 'Restart systemu za 3..2'
sleep 1
echo 'Restart systemu za 3..2..1'
sleep 1







