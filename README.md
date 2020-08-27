# WireGuad Automation Script
All files stored in **/etc/wireguard**
* Public & Private Key
* Config File

## To Install Wiguread

> git clone https://github.com/AnonyKwan/WireGuard-Automation-Installation-UserAdding.git

> chmod +x WireGuard*

> sudo ./WireGuard-Install.sh

## To Add WireGuard User

> sudo ./WireGuard-AddUser.sh

## To re-generate the QR Code

> qrencode -t ansiutf8 < {Config File}

> eg: qrencode -t ansiutf8 < /etc/wireguard/Example_192.168.1.1_Config.conf
