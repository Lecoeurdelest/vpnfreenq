#!/bin/bash
set -e
NAME=$1
PKI_DIR="/etc/openvpn/pki"
OUTPUT_DIR="/etc/openvpn/clients"

if [ -z "$NAME" ]; then
  echo "Usage: gen_client.sh <client_name>"
  exit 1
fi

mkdir -p $OUTPUT_DIR
cd $PKI_DIR
easyrsa gen-req $NAME nopass
echo "yes" | easyrsa sign-req client $NAME

# Tạo file .ovpn
/usr/local/bin/scripts/make_config.sh $NAME > $OUTPUT_DIR/$NAME.ovpn
echo "[*] Client config created: $OUTPUT_DIR/$NAME.ovpn"
