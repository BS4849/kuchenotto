#!/bin/bash
dhcp=/etc/dhcpcd.conf
wpa=/etc/wpa_supplicant/wpa_supplicant.conf
edimax=/etc/modprobe.d/8192cu.conf
script=`readlink -f "$0"`
scriptpath=`dirname $script`
h=8
w=78
#------------------------------------------------------------------------
whiptail --title "Willkommen!" --msgbox "Dies ist ein Script!" $h $w
if (whiptail --title "Wähle aus!" --yes-button "eth0" --no-button "wlan0"  --yesno "Welche Schnittstelle möchtest du einstellen?" $h $w); then
inet=eth0
else
inet=wlan0
fi
#------------------------------------------------------------------------
if [ $inet == wlan0 ]; then
if (whiptail --title "Edimax?" --yes-button "JA!" --no-button "NEIN!"  --yesno "Benutzt du den Edimax-Wlan-Stick?" $h $w); then
echo 'options 8192cu rtw_power_mgnt=0 rtw_enusbss=0' >> $edimax
else
sleep 0.1
fi
else
sleep 0.1
fi
if [ $inet == wlan0 ]; then
sudo cp $wpa $wpa.backup
sudo chmod 777 $wpa
ssid=`whiptail --title "SSID" --inputbox "Gib den Netzwerknamen ein!" $h $w  3>&1 1>&2 2>&3`
pw=`whiptail --title "PASSWORT" --passwordbox "Gib das Passwort ein und bestätige mit OK!" $h $w  3>&1 1>&2 2>&3`
staticip=`whiptail --title "STATICIP" --inputbox "Wie soll die statische IP für $inet heißen?" $h $w  3>&1 1>&2 2>&3`
gateway=`whiptail --title "GATEWAY" --inputbox "Wie soll der Gateway für $inet heißen?" $h $w 192.168.0.1 3>&1 1>&2 2>&3`
dns=`whiptail --title "DNS" --inputbox "Wie soll der DNS für $inet heißen?" $h $w 192.168.0.1 3>&1 1>&2 2>&3`
echo 'network={' >> $wpa
echo 'ssid="'$ssid'"' >> $wpa
echo 'psk="'$pw'"' >> $wpa
echo '}' >> $wpa
sudo chmod 600 $wpa
else
staticip=`whiptail --title "STATICIP" --inputbox "Wie soll die statische IP für $inet heißen?" $h $w  3>&1 1>&2 2>&3`
gateway=`whiptail --title "GATEWAY" --inputbox "Wie soll der Gateway für $inet heißen?" $h $w 192.168.0.1 3>&1 1>&2 2>&3`
dns=`whiptail --title "DNS" --inputbox "Wie soll der DNS für $inet heißen?" $h $w 192.168.0.1 3>&1 1>&2 2>&3`
fi
#------------------------------------------------------------------------
echo interface $inet >> $dhcp
echo static ip_address=$staticip/24 >> $dhcp
echo static routers=$gateway >> $dhcp
echo static domain_name_servers=$dns >> $dhcp
sudo systemctl daemon-reload
sudo service networking reload
#------------------------------------------------------------------------
echo Reboot!
sleep 1
echo .
sleep 1
echo ..
sleep 1
echo ...
sleep 1
sudo reboot
