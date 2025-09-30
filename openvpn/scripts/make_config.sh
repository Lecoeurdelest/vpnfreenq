#!/bin/bash
set -e
NAME=$1
PKI_DIR="/etc/openvpn/pki"

cat <<EOF
client
dev tun
proto udp
remote myserver.com 1194
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-CBC
verb 3
key-direction 1

<ca>
$(cat $PKI_DIR/ca.crt)
</ca>
<cert>
$(cat $PKI_DIR/issued/$NAME.crt)
</cert>
<key>
$(cat $PKI_DIR/private/$NAME.key)
</key>
<tls-auth>
$(cat $PKI_DIR/ta.key)
</tls-auth>
EOF
