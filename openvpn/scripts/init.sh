#!/bin/bash
set -e

CONFIG="/etc/openvpn/server.conf"
PKI_DIR="/etc/openvpn/pki"

# Function to print messages
log_message() {
  echo "[*] $1"
}

if [ ! -f "$CONFIG" ]; then
  log_message "First time setup: Initializing PKI..."
  mkdir -p "$PKI_DIR"
  cd "$PKI_DIR"
  
  # Create vars file to avoid interactive prompts
  cat > vars << EOF
set_var EASYRSA_REQ_COUNTRY "US"
set_var EASYRSA_REQ_PROVINCE "California"
set_var EASYRSA_REQ_CITY "San Francisco"
set_var EASYRSA_REQ_ORG "OpenVPN"
set_var EASYRSA_REQ_EMAIL "admin@example.com"
set_var EASYRSA_REQ_OU "IT"
set_var EASYRSA_REQ_CN "OpenVPN CA"
set_var EASYRSA_BATCH "yes"
EOF

  log_message "Initializing PKI..."
  easyrsa init-pki
  
  log_message "Building CA certificate..."
  easyrsa --batch build-ca nopass
  
  log_message "Generating server certificate request..."
  easyrsa --batch --req-cn=server gen-req server nopass
  
  log_message "Signing server certificate..."
  easyrsa --batch sign-req server server

  # DH parameters
  easyrsa gen-dh

  # TLS key
  openvpn --genkey --secret "$PKI_DIR/pki/ta.key"

  # Generate server.conf
  cat <<EOF > "$CONFIG"
port 1194
proto udp
dev tun
ca $PKI_DIR/pki/ca.crt
cert $PKI_DIR/pki/issued/server.crt
key $PKI_DIR/pki/private/server.key
dh $PKI_DIR/pki/dh.pem
tls-auth $PKI_DIR/pki/ta.key 0
server 10.8.0.0 255.255.255.0
ifconfig-pool-persist ipp.txt
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
keepalive 10 120
cipher AES-256-CBC
persist-key
persist-tun
status /etc/openvpn/openvpn-status.log
verb 3
EOF

  echo "[*] PKI and server.conf generated."
fi

echo "[*] Starting OpenVPN..."
exec openvpn --config "$CONFIG"
