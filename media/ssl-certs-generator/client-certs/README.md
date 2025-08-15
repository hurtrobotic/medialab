# Commandline operations

# generate client private key
```
openssl genrsa -out ws-client.key 4096
```

# generate csr for client

```
openssl req -new -key ws-client.key -out ws-client.csr -config ws-client.cnf
```

# generate certificate

```
openssl x509 -req -in ws-client.csr -CA ../ca/ca.pem -CAkey ../ca/ca-key.pem -CAcreateserial -out ws-client.pem -days 36500 -extensions v3_req -extfile ws-client.cnf
```

# Build du keystore pour le browser
```
openssl pkcs12 -export -chain -CAfile ../ca/ca.pem -in ws-client.pem -inkey ws-client.key -out ws-client.p12 -name personal -passout pass:password
```