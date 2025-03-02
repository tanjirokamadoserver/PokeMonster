PASSO A PASSO:

#CRIANDO MÁQUINA VIRTUAL -> https://www.youtube.com/watch?v=r7ssIhk0GQ8
#DOWNLOAD DEBIAN: https://www.debian.org/releases/index.pt.html
#DOWNLOAD UBUNTU: https://ubuntu.com/download/alternative-downloads

LINUX PACK: https://drive.google.com/file/d/1iLDOYMzDLcd9OnO_OVSzI6uJi_zftebs/view?usp=sharing


su -  (caso não esteja com acesso root)

apt update
apt upgrade

apt install mariadb-server
mariadb-secure-installation
apt install php
apt install phpmyadmin
echo "Include /etc/phpmyadmin/apache.conf" | tee -a /etc/apache2/apache2.conf
/etc/init.d/apache2 restart

apt install libcrypto++-dev autoconf git cmake build-essential gdb screen gawk libboost-all-dev libgmp3-dev liblua5.1-0 liblua5.1-0-dev lua5.1 libxml2-dev libxml++2.6-dev zlib1g-dev zlib1g  libssl-dev libmariadb-dev libmariadb-dev-compat cpp gcc g++ make automake libtool m4 pkg-config autoconf-archive libxml2 libxml2-dev libgmp-dev libluajit-5.1-dev libboost-date-time-dev libboost-system-dev libboost-iostreams-dev libpugixml-dev libfmt-dev

cd /etc/php
ls  (para verificar a VERSÃO_DO_PHP)
cd VERSÃO_DO_PHP/apache2
nano php.ini
memory_limit = 512M
post_max_size = 512M
upload_max_filesize = 512M
service apache2 restart
service mysql restart

#CRIAR USUÁRIO
  mysql -u root -p
  CREATE USER 'NOME_DO_USUARIO'@'%' IDENTIFIED BY 'SENHA_DO_USUARIO';
  GRANT ALL PRIVILEGES ON *.* TO 'NOME_DO_USUARIO'@'%' WITH GRANT OPTION;
  FLUSH PRIVILEGES;

quit

cd ../../../../../../..

#IMPORTAR DATABASE (CASO ESTEJA USANDO MÁQUINA VIRTUAL E/OU NÃO CONSIGA IMPORTAR PELO PHPMYADMIN)
  cd DIRETORIO_RAIZ_ONDE_ESTA_O_ARQUIVO
  mysql -u NOME_DO_USUARIO -p NOME_DA_DB < NOME_DO_ARQUIVO.sql

#FIREWALL
  apt-get install ufw
  ufw allow 7171/tcp
  ufw allow 7172/tcp
  ufw allow 80/tcp
  ufw allow 43/tcp
  ufw allow 3306/tcp
  ufw allow 8080/tcp
  ufw allow 21/tcp
  ufw allow 22/tcp
  ufw enable
  ufw status

#PERMITIR ACESSO GLOBAL
  nano /etc/mysql/mariadb.conf.d/50-server.cnf
  bind-address = 127.0.0.1  alterar para 0.0.0.0
  service mysql restart
  

#EXTRAS:
  cd ../../../../../..
  nano /etc/phpmyadmin/apache.conf
  
  EM: <Directory /usr/share/phpmyadmin>
    ADICIONAR: AllowOverride All

  systemctl restart apache2

  nano /usr/share/phpmyadmin/.htaccess
    AuthType Basic
    AuthName "Restricted Files"
    AuthUserFile /usr/share/phpmyadmin/.htpasswd
    Require valid-user

  htpasswd -c /usr/share/phpmyadmin/.htpasswd NOME_DO_USUARIO


  https://pt.linux-console.net/?p=6537#gsc.tab=0    (habilitar certificado SSL/HTTPS)


  
#UTIL:
  https://github.com/SkullzOTS/DebianTFS/commit/48be07d6d7fe29c973fa7beb16377528a1f17c68
  https://otland.net/threads/c-linux-compiling-old-engine-sources-on-debian-10-ubuntu-20-04.274654/




#https://github.com/otland/forgottenserver/wiki/Compiling-on-Debian-GNU-Linux
cd DIRETORIO_DO_SERVER
mkdir build && cd build
cmake ..
make