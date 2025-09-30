#!/bin/bash
set -e
NAME=$1
PKI_DIR="/etc/openvpn/pki"

if [ -z "$NAME" ]; then
  echo "Usage: revoke_client.sh <client_name>"
  exit 1
fi

cd $PKI_DIR
echo "yes" | easyrsa revoke $NAME
easyrsa gen-crl
cp $PKI_DIR/crl.pem /etc/openvpn/crl.pem
echo "[*] Client $NAME revoked."
