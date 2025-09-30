FROM debian:stable-slim

ARG OPENVPN_VERSION=2.6.10
ARG EASYRSA_VERSION=3.1.7

RUN apt-get update && apt-get install -y \
    build-essential wget iproute2 iptables openssl \
    libssl-dev lz4 liblz4-dev liblzo2-dev pkg-config git bash dos2unix \
    libnl-3-dev libnl-genl-3-dev libcap-ng-dev libpam0g-dev \
    && rm -rf /var/lib/apt/lists/*

# Build OpenVPN
RUN wget https://swupdate.openvpn.org/community/releases/openvpn-${OPENVPN_VERSION}.tar.gz && \
    tar xzf openvpn-${OPENVPN_VERSION}.tar.gz && \
    cd openvpn-${OPENVPN_VERSION} && \
    ./configure && make && make install && \
    cd .. && rm -rf openvpn-${OPENVPN_VERSION}*

# Install EasyRSA
RUN wget https://github.com/OpenVPN/easy-rsa/releases/download/v${EASYRSA_VERSION}/EasyRSA-${EASYRSA_VERSION}.tgz && \
    tar xzf EasyRSA-${EASYRSA_VERSION}.tgz && \
    mv EasyRSA-${EASYRSA_VERSION} /usr/local/share/easy-rsa && \
    ln -s /usr/local/share/easy-rsa/easyrsa /usr/local/bin/easyrsa && \
    rm EasyRSA-${EASYRSA_VERSION}.tgz

WORKDIR /etc/openvpn
VOLUME ["/etc/openvpn"]

COPY scripts /usr/local/bin/scripts
RUN find /usr/local/bin/scripts -type f -name "*.sh" -exec dos2unix {} \; && \
    chmod -R 755 /usr/local/bin/scripts && \
    chmod +x /usr/local/bin/scripts/init.sh

ENTRYPOINT ["bash", "/usr/local/bin/scripts/init.sh"]
