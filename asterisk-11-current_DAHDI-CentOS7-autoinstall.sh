#!/bin/bash
#

clear

#Kernel

yum install kernel-devel -y
sleep 2

#VORBIS

yum install libvorbis libvorbis-devel vorbis-tools libogg libogg-devel -y
sleep 2

#CURL

yum install curl curl-devel libidn-devel -y
sleep 2


#Dependencies and compilation packages

yum install gcc ncurses-devel make gcc-c++ mingw64-termcap-static zlib-devel libtool bison-devel bison openssl-devel bzip2-devel wget newt-devel subversion flex gtk2-devel net-tools -y
sleep 2


#MariaDB

yum install mariadb mariadb-server mariadb-devel -y
sleep 2

#ODBC

yum install unixODBC unixODBC-devel mysql-connector-odbc libtool-ltdl-devel -y
sleep 2

#SQlite:

yum install sqlite sqlite-devel -y
sleep 2

#Festival (para voces)

yum install festival festival-devel hispavoces-pal-diphone hispavoces-sfl-diphone -y
sleep 2

#Libuuid y uiid for the correct compilation of PjSIP & ICE on Asterisk:

yum install libuuid libuuid-devel uuid uuid-devel -y
sleep 2

#Speex y WavPack:

yum install speex speex-devel wavpack wavpack-devel -y
sleep 2

#Lame from the fonts:

cd /usr/src 

wget https://sourceforge.net/projects/lame/files/lame/3.99/lame-3.99.5.tar.gz 

tar -xf lame-3.99.5.tar.gz 

cd lame-3.99.5 

./configure --prefix=/usr --libdir=/usr/lib64/ 

make 

make install

echo "Lame was installed succesfully\n"

#Libmad from the fonts:

cd /usr/src 

wget http://prdownloads.sourceforge.net/mad/libmad-0.15.1b.tar.gz 

tar -xf libmad-0.15.1b.tar.gz 

cd libmad-0.15.1b 

./configure --prefix=/usr --libdir=/usr/lib64/


nano +129 Makefile


CFLAGS = -Wall -g -O -fforce-mem -fforce-addr -fthread-jumps -fcse-follow-jumps -fcse-skip-blocks -fexpensive-optimizations -fregmove -fschedule-insns2

#To:

CFLAGS = -Wall -g -O -fforce-addr -fthread-jumps -fcse-follow-jumps -fcse-skip-blocks -fexpensive-optimizations -fregmove -fschedule-insns2

make 

make install

echo "Libmad was installed succesfully\n"


#SoX from the fonts:

cd /usr/src 

wget http://downloads.sourceforge.net/project/sox/sox/14.4.1/sox-14.4.1.tar.gz 

tar -xf sox-14.4.1.tar.gz 

cd sox-14.4.1 

./configure --prefix=/usr --libdir=/usr/lib64/ 

make 

make install

echo "Libmad was installed succesfully\n"


#Time to compile in this correct order DAHDI y LibPRI:

cd /usr/src 

wget http://downloads.asterisk.org/pub/telephony/dahdi-linux-complete/dahdi-linux-complete-current.tar.gz

tar -xf dahdi-linux-complete-current.tar.gz 

cd dahdi-linux-complete-2.10.0+2.10.0 

make 

make install 

make config



#Start DAHDI with the old launch system:

#Existe un bug a partir de la versión 2.11 de dahdi, y es que el make config no termina de crear el archivo de arranque, para eso podemos copiar cualquier archivo de arranque de dahdi y colocarlo en el directorio /etc/init.d/ y asignarle permisos de ejecución con chmod 755

cd /usr/src 

wget http://downloads.asterisk.org/pub/telephony/libpri/libpri-current.tar.gz 

tar -xf libpri-1.4.14.tar.gz 

cd libpri-1.4.14 

make 

make install


#download Asterisk, version 11:

cd /usr/src 

wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-11-current.tar.gz

tar -xf asterisk-11-current.tar.gz 

cd asterisk-11.25.1 

./contrib/scripts/install_prereq install

./configure --libdir=/usr/lib64 

make menuselect

./contrib/scripts/get_mp3_source.sh 

make 

make install 

make samples

make config 

sleep 2


touch /usr/lib/systemd/system/asterisk.service



#Fill with this contain


echo "[Unit]" >> /usr/lib/systemd/system/asterisk.service 
echo "Description=Asterisk PBX" >> /usr/lib/systemd/system/asterisk.service
echo "Documentation=man:asterisk(8)" >> /usr/lib/systemd/system/asterisk.service 
echo "Wants=network-online.target" >> /usr/lib/systemd/system/asterisk.service 
echo "After=network-online.target" >> /usr/lib/systemd/system/asterisk.service
echo "" >> /usr/lib/systemd/system/asterisk.service

echo "[Service]" >> /usr/lib/systemd/system/asterisk.service 
echo "ExecStart=/usr/sbin/asterisk -g -f" >> /usr/lib/systemd/system/asterisk.service
echo "ExecReload=/usr/sbin/asterisk -rx 'core reload'" >> /usr/lib/systemd/system/asterisk.service
echo "Restart=always" >> /usr/lib/systemd/system/asterisk.service
echo "RestartSec=1" >> /usr/lib/systemd/system/asterisk.service
echo "WorkingDirectory=/usr/sbi" >> /usr/lib/systemd/system/asterisk.service
echo "" >> /usr/lib/systemd/system/asterisk.service

echo "[Install]" >> /usr/lib/systemd/system/asterisk.service
echo "WantedBy=multi-user.targe" >> /usr/lib/systemd/system/asterisk.service

systemctl enable asterisk

reboot

#END
