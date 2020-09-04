#/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    exit 1
fi

read -p "ASSIGN IP ADDRESS TO THE USER (UNDER YOUR IP RANGE!):  " ip_address
read -p "USER DESC:  " user
read -p "Public IP/Domain:  " pub_ip

wg genkey | tee /etc/wireguard/$user'_'$ip_address'_PrivateKey' | wg pubkey > /etc/wireguard/$user'_'$ip_address'_PublicKey'

server_publickey="$(cat /etc/wireguard/Server_PublicKey)"
user_publickey="$(cat /etc/wireguard/$user'_'$ip_address'_PublicKey')"
user_privatekey="$(cat /etc/wireguard/$user'_'$ip_address'_PrivateKey')"

echo "" >> /etc/wireguard/wg0.conf
echo "#$user" >> /etc/wireguard/wg0.conf
echo "[Peer]" >> /etc/wireguard/wg0.conf
echo "PublicKey = $user_publickey"  >> /etc/wireguard/wg0.conf
echo "AllowedIPs = $ip_address/32" >> /etc/wireguard/wg0.conf
echo "" >> /etc/wireguard/wg0.conf


wg-quick down wg0
wg-quick up wg0


echo "[Interface]" > /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "Address = $ip_address/32" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "PrivateKey = $user_privatekey" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "DNS = 8.8.8.8" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "MTU = 1420" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "[Peer]" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "PublicKey = $server_publickey" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "Endpoint = $pub_ip":1024" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'
echo "AllowedIPs = 0.0.0.0/0" >> /etc/wireguard/$user'_'$ip_address'_Config.conf'

qrencode -t ansiutf8 < "/etc/wireguard/$user"_"$ip_address"_"Config.conf"

wg show

echo -e "\e[1;31m The Confi file is stroed /etc/wireguard/$user"_"$ip_address"_"Config.conf  \e[0m"
