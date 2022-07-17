#!/bin/sh

# Write Code configuration
rm -rf /etc/Appp/c0nfig.json
cat << EOF > /etc/Appp/c0nfig.json
{
  "inbounds": [
    {
      "port": 443,
      "protocol": "vless",
      "settings": {
        "decryption": "none",
        "clients": [
          {
            "id": "c13e10f7-4a4f-4c3b-94f6-a281e26b7a28"
          }
        ]
      },
      "streamSettings": {
        "network": "ws"
		"wsSettings": {
                "path": "/"
            }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

# Get Code executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/XTLS/Xray-core/releases/download/v1.5.5/Xray-linux-64.zip -o /etc/Appp/Code_dist.zip
busybox unzip /etc/Appp/Code_dist.zip -d /etc/Appp

#Rename
mv xray t3st

# Install App
install -m 755 /etc/Appp/t3st
rm -rf /etc/Appp/Code_dist.zip

# Run App
/etc/Appp/t3st -/etc/Appp/c0nfig.json
