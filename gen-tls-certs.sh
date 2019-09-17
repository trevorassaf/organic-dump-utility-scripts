#!/bin/bash

PRIVATE_CA_DIR=ca/private
PRIVATE_SERVER_DIR=server/private
PRIVATE_CLIENT_DIR=client/private

# Generate a self signed certificate for the CA along with a key
mkdir -p $PRIVATE_CA_DIR 
chmod 700 $PRIVATE_CA_DIR
openssl req \
    -x509 \
    -nodes \
    -days 3650 \
    -newkey rsa:4096 \
    -keyout $PRIVATE_CA_DIR/ca_key.pem \
    -out ca/ca_cert.pem \
    -subj "/C=US/ST=Acme State/L=Acme City/O=Acme Inc./CN=example.com"

# Create server private key and certificate request
mkdir -p $PRIVATE_SERVER_DIR 
chmod 700 $PRIVATE_SERVER_DIR
openssl genrsa -out $PRIVATE_SERVER_DIR/server_key.pem 4096
openssl req -new \
    -key $PRIVATE_SERVER_DIR/server_key.pem \
    -out server/server.csr \
    -subj "/C=US/ST=Acme State/L=Acme City/O=Acme Inc./CN=server.example.com"

# Create client private key and certificate request
mkdir -p $PRIVATE_CLIENT_DIR
chmod 700 $PRIVATE_CLIENT_DIR 
openssl genrsa -out $PRIVATE_CLIENT_DIR/client_key.pem 4096
openssl req -new \
    -key $PRIVATE_CLIENT_DIR/client_key.pem \
    -out client/client.csr \
    -subj "/C=US/ST=Acme State/L=Acme City/O=Acme Inc./CN=client.example.com"

# Generate certificates
openssl x509 -req -days 1460 -in server/server.csr \
    -CA ca/ca_cert.pem -CAkey $PRIVATE_CA_DIR/ca_key.pem \
    -CAcreateserial -out server/server_cert.pem
openssl x509 -req -days 1460 -in client/client.csr \
    -CA ca/ca_cert.pem -CAkey $PRIVATE_CA_DIR/ca_key.pem \
    -CAcreateserial -out client/client_cert.pem

# Now test both the server and the client
# On one shell, run the following
openssl s_server -CAfile ca/ca_cert.pem -cert server/server_cert.pem -key $PRIVATE_SERVER_DIR/server_key.pem -Verify 1
# On another shell, run the following
openssl s_client -CAfile ca/ca_cert.pem -cert client/client_cert.pem -key $PRIVATE_CLIENT_DIR/client_key.pem
# Once the negotiation is complete, any line you type is sent over to the other side.
# By line, I mean some text followed by a keyboar return press.
