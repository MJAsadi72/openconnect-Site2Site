# openconnect-site2site
openconnect site2site connection 

## Requirment

**openconnect**

**ocserv**

**iproute2**

**vpn-slice(install it using pip3)**

**iptables(perhaps default installed on your distro**

InServer: Openwrt-21.02.5

OutServer: Ubuntu 20.04
## How it's Work

1. install Requirments
2. config ocserv on Out and In servers (use configs at this repo and create certs yourself)
3. create users for ocservs 
4. run script.sh on InServer 
5. connect your client to InServer

