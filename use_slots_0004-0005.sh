#!/bin/bash

# New Slot IDs
SLOT_KEY=0xF0000004
SLOT_CERT=0xF0000005

# 1. Generate Key and Cert (standard OpenSSL)
# In this example, "MyRT1060_New" is the name of the THING
# Create the key pair
openssl ecparam -name prime256v1 -genkey -noout -out device_ec_key.pem
#create the certificate
openssl req -new -x509 -key device_ec_key.pem -out device_ec_cert.pem -days 365 -subj "/CN=MyRT1060_New"

# 2. Inject Private Key into 0xF0000004
echo "Injecting Key into 0xF0000004..."
ssscli set ecc pair %SLOT_KEY% device_ec_key.pem

# 3. Inject Certificate into 0xF0000005
echo "Injecting Certificate into 0xF0000005..."
ssscli set cert %SLOT_CERT% device_ec_cert.pem

# 4. Verify they are there
echo "Verifying..."
ssscli se05x readidlist

