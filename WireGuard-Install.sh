#/bin/bash

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    exit 1
fi

read -p "Set Up the IP Range (eg: 192.168.255.0)" ip_range

deb http://deb.debian.org/debian buster-backports main

echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable-wireguard.list
printf 'Package: *\nPin: release a=unstable\nPin-Priority: 150\n' > /etc/apt/preferences.d/limit-unstable

apt update & apt upgrade -y

apt install wireguard-dkms wireguard-tools qrencode -y

wg genkey | tee /etc/wireguard/Server_PrivateKey | wg pubkey > /etc/wireguard/Server_PublicKey

privatekey="$(cat /etc/wireguard/Server_PrivateKey)"

echo "[Interface]" >> /etc/wireguard/wg0.conf
echo "PrivateKey = $privatekey" >> /etc/wireguard/wg0.conf
echo "Address = $ip_range/24" >> /etc/wireguard/wg0.conf
echo "ListenPort = 1024" >> /etc/wireguard/wg0.conf
echo "PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE" >> /etc/wireguard/wg0.conf
echo "PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE" >> /etc/wireguard/wg0.conf

wg-quick up wg0

systemctl enable wg-quick@wg0

sysctl -w net.ipv4.ip_forward=1


sleep 2

echo -e "\e[1;31m Installation Finished, Run the AddUser Script \e[0m"

