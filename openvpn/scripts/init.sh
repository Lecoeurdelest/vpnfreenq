#!/bin/bash
set -e

CONFIG="/etc/openvpn/server.conf"
PKI_DIR="/etc/openvpn/pki"

if [ ! -f "$CONFIG" ]; then
  echo "[*] First time setup: Initializing PKI..."
  mkdir -p $PKI_DIR
  cd $PKI_DIR
  easyrsa init-pki
  echo -ne "\n" | easyrsa build-ca nopass
  easyrsa gen-req server nopass
  echo "yes" | easyrsa sign-req server server
  easyrsa gen-dh
  openvpn --genkey secret ta.key

  cat <<EOF > $CONFIG
port 1194
proto udp
dev tun
ca $PKI_DIR/ca.crt
cert $PKI_DIR/issued/server.crt
key $PKI_DIR/private/server.key
dh $PKI_DIR/dh.pem
tls-auth $PKI_DIR/ta.key 0
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-CBC
persist-key
persist-tun
status openvpn-status.log
verb 3
EOF
fi

echo "[*] Starting OpenVPN..."
exec openvpn --config "$CONFIG"
