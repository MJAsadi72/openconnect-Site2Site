#!/bin/bash

iptables -t mangle -A PREROUTING -s 192.168.68.0/24 -m geoip ! --destination-country  IR -j MARK --set-xmark 0x10000/0xff0000
iptables -t nat -A PREROUTING -s 192.168.68.0/24 -m geoip ! --destination-country  IR -j MARK --set-xmark 0x10000/0xff0000
iptables -t nat -A POSTROUTING -s 192.168.68.0/24 -j MASQUERADE
openconnect  <OutServer_IP>  --no-dtls --background --user=<USERNAME_OF_OUT_OCSERV> --passwd-on-stdin --servercert <SERVER_CERT> -s 'vpn-slice 10.12.0.0/24' < passwd.auth
while true 
do
	if ip a | grep -q tun0
	then
		ip rule add from all fwmark 0x10000/0xff0000 lookup vpn
		ip route add default dev tun0 table vpn 
		break
	fi
	sleep 5
done
