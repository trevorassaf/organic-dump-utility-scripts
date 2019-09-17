#!/bin/sh

GLOBAL_PATH_FOR_PROJECT_ROOT="/home/bozkurtus/Documents/codez/personal-repos/organic-dump/organic-dump-project"

CLIENT_APP_FROM_PROJECT_ROOT="out/code/organic-dump-client-application/repo"
SERVER_APP_FROM_PROJECT_ROOT="out/code/organic-dump-server-application/repo"

CLIENT_APP="$GLOBAL_PATH_FOR_PROJECT_ROOT/$CLIENT_APP_FROM_PROJECT_ROOT/test_crypto_client"
SERVER_APP="$GLOBAL_PATH_FOR_PROJECT_ROOT/$SERVER_APP_FROM_PROJECT_ROOT/test_crypto_server"

GLOBAL_PATH_FOR_TLS_CERT_ROOT="/home/bozkurtus/Documents/codez/personal-repos/tls-certs/github-cert-generation"
CA_CERT="$GLOBAL_PATH_FOR_TLS_CERT_ROOT/ca/ca_cert.pem"

CLIENT_CERT_ROOT="$GLOBAL_PATH_FOR_TLS_CERT_ROOT/client"
CLIENT_KEY="$CLIENT_CERT_ROOT/private/client_key.pem"
CLIENT_CERT="$CLIENT_CERT_ROOT/client_cert.pem"

SERVER_CERT_ROOT="$GLOBAL_PATH_FOR_TLS_CERT_ROOT/server"
SERVER_KEY="$SERVER_CERT_ROOT/private/server_key.pem"
SERVER_CERT="$SERVER_CERT_ROOT/server_cert.pem"

PORT=5555

#$SERVER_APP --help

echo "CA cert: $CA_CERT"

echo "Server key: $SERVER_KEY"
echo "Server cert: $SERVER_CERT"

echo "Client key: $CLIENT_KEY"
echo "Client cert: $CLIENT_CERT"

$SERVER_APP \
  -cert $SERVER_CERT \
  -key $SERVER_KEY \
  -ca $CA_CERT \
  -port $PORT \
  -message 'Test message from server' &

$CLIENT_APP \
  -cert $CLIENT_CERT \
  -key $CLIENT_KEY \
  -ca $CA_CERT \
  -port $PORT \
  -ipv4 127.0.0.1 \
  -message 'Test message from client'
