#!/bin/bash
# Generate password hash
[ -z "$1" ] && echo "enter username" && exit 1
[ -z "$2" ] && echo "enter password" && exit 2
grep -q "name \'$1\'" /etc/config/ocserv && echo "name exist" && exit 3
OC_USER=$1
OC_PASS=$2
ocpasswd ${OC_USER} << EOF
${OC_PASS}
${OC_PASS}
EOF
OC_HASH="$(sed -n -e "/^${OC_USER}:.*:/s///p" /etc/ocserv/ocpasswd)"
 
# Fetch password hash
echo ${OC_HASH}
#id=$(cat /etc/config/ocserv   | grep "ocservusers" | wc -l)
client=$(cat /proc/sys/kernel/random/uuid | sed 's/[-]//g' | head -c 8; echo;)
uci -q delete ocserv.${client}
uci set ocserv.${client}="ocservusers"
uci set ocserv.${client}.name=${OC_USER}
uci set ocserv.${client}.password=${OC_HASH}
uci commit ocserv
grep -w  ${OC_USER}  /etc/ocserv/ocpasswd >> /var/etc/ocpasswd
