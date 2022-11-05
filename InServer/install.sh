opkg update
opkg install ocserv openconnect python3-pip kmod-tcp-bbr kmod-sched iptables-mod-geoip ss tc-full
pip install vpn-slice

OC_PORT="443"
OC_POOL="192.168.68.0 255.255.255.0"
OC_DNS="8.8.8.8"
OC_USER="${1}"
OC_PASS="${2}"
ocpasswd ${OC_USER} << EOF
${OC_PASS}
${OC_PASS}
EOF
OC_HASH="$(sed -n -e "/^${OC_USER}:.*:/s///p" /etc/ocserv/ocpasswd)"

# Fetch password hash
echo ${OC_HASH}
uci -q delete ocserv.config.enable
uci -q delete ocserv.config.zone
uci set ocserv.config.port="${OC_PORT}"
uci set ocserv.config.ipaddr="${OC_POOL% *}"
uci set ocserv.config.netmask="${OC_POOL#* }"
uci -q delete ocserv.@routes[0]
uci -q delete ocserv.@dns[0]
uci set ocserv.dns="dns"
uci set ocserv.dns.ip="${OC_DNS}"
uci -q delete ocserv.@ocservusers[0]
uci set ocserv.client="ocservusers"
uci set ocserv.client.name="${OC_USER}"
uci set ocserv.client.password="${OC_HASH}"
uci commit ocserv
/etc/init.d/uhttpd stop
/etc/init.d/uhttpd disable
/etc/init.d/ocserv restart

mkdir -p /usr/share/xt_geoip
echo "1 vpn" >> /etc/iproute2/rt_tables

