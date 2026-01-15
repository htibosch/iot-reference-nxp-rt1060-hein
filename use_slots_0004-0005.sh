#!/bin/bash

# New Slot IDs
SLOT_KEY=0xF0000004
SLOT_CERT=0xF0000005

# 1. Generate Key and Cert (standard OpenSSL)
# In this example, "MyRT1060_04" is the name of the THING

# Create the key pair
openssl ecparam -name prime256v1 -genkey -noout -out device_ec_key.pem

#create the certificate
openssl req -new -x509 -key device_ec_key.pem -out device_ec_cert.pem -days 365 -subj "/CN=MyRT1060_04"

# 2. Inject Private Key into 0xF0000004
echo "Injecting Key into 0xF0000004..."
ssscli set ecc pair $SLOT_KEY device_ec_key.pem

# 3. Inject Certificate into 0xF0000005
echo "Injecting Certificate into 0xF0000005..."
ssscli set cert $SLOT_CERT device_ec_cert.pem

# 4. Verify they are there
echo "Verifying..."
ssscli se05x readidlist

# lookup my endpoint:

aws iot describe-endpoint --endpoint-type iot:Data-ATS --region us-west-2

#   Expect something like:
#
#   "endpointAddress": "a2x86ax5wuxkmz-ats.iot.us-west-2.amazonaws.com"
#
# In app_main.c:

#define appmainPROVISIONING_MODE                  ( 1 )

# And configure the SE05 :

conf set thing_name         MyRT1060_04
conf set mqtt_endpoint      a2x86ax5wuxkmz-ats.iot.us-west-2.amazonaws.com
conf set mqtt_port          8883
conf set priv_key_id        sss:F0000004
conf set pub_key_id         Device Pub TLS Key
conf set cert_id            sss:F0000005
conf set priv_root_ca_id    JITP Cert
conf set aws_root_ca_id     Root Cert
conf set codeverify_key_id  sss:00223344
conf list

# The conf list command will print all key/value pairs

# thing_name         = 'MyRT1060_04'
# mqtt_endpoint      = 'a2x86ax5wuxkmz-ats.iot.us-west-2.amazonaws.com'
# mqtt_port          = '8883'
# priv_key_id        = 'sss:F0000004'
# pub_key_id         = 'Device Pub TLS Key'
# cert_id            = 'sss:F0000005'
# priv_root_ca_id    = 'JITP Cert'
# aws_root_ca_id     = 'Root Cert'
# codeverify_key_id  = 'sss:00223344'
