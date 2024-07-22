#!/bin/bash
if ! [ $(id -u) = 0 ]; then
    echo "Must be run as root."
exit 1
fi

clear

echo "=================================================================================================="
echo "The only check this script does is for root access. Read it first and understand what it is doing."
echo "=================================================================================================="
echo "1. Create user account."
echo "2. Update Debian installation and install deps."
echo "3. Download latest OLA from git, compile and install it."
echo "4. Rewrite /etc/issue to include web control panel address."
echo "4. Install and enable systemd service."
echo "5. Reboot."
echo "=================================================================================================="
echo "===========================!You will not be prompted before the reboot!=========================== "
echo "=================================================================================================="

read -p "OLA User to create [ola]:" olad_user
olad_user=${olad_user:-ola}

useradd $olad_user

apt -y update
apt -y upgrade
apt -y install libcppunit-1.15-0 libcppunit-dev uuid-dev pkg-config libncurses5-dev libtool autoconf automake g++ libmicrohttpd-dev  protobuf-compiler  libprotobuf-dev libprotoc-dev zlib1g-dev bison flex make libftdi-dev libftdi1 libusb-1.0-0-dev liblo-dev libavahi-client-dev libmicrohttpd12  libprotobuf-lite32 python3-protobuf python3-numpy git

cd /home/$olad_user
su $olad_user -c "git clone https://github.com/OpenLightingProject/ola.git ola"
cd ola
su $olad_user -c "autoreconf -i"
su $olad_user -c "./configure --disable-doxygen-doc --enable-python-libs --enable-rdm-tests --enable-e133" 
su $olad_user -c "make"


cd /home/$olad_user/ola
make install
ldconfig

rm /etc/issue
touch  /etc/issue

tee -a /etc/issue <<EOF
Open Lighting Architecture

Web Interface: http://\4:9090
EOF

touch  /etc/systemd/system/olad.service

tee -a /etc/systemd/system/olad.service <<EOF
[Unit]
Description=Open Lighting Architecture

[Service]
User=$olad_user
Type=Simple
ExecStart=olad -l 3
Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl enable olad

reboot
