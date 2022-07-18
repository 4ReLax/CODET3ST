#!/bin/sh

# Global variables
DIR_CONFIG="/etc/Appp"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"
mkdir -p ${DIR_CONFIG}

# Write V2Ray configuration
cat << EOF > ${DIR_CONFIG}/c0nfig.json
{
  "inbounds": [
    {
      "listen": "0.0.0.0",
	  "port": 443,
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "c13e10f7-4a4f-4c3b-94f6-a281e26b7a28"
          }
        ],
		"decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
		"security": "none",
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

# Get V2Ray executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/XTLS/Xray-core/releases/download/v1.5.5/Xray-linux-64.zip -o ${DIR_TMP}/dist.zip
busybox unzip ${DIR_TMP}/dist.zip -d ${DIR_TMP}

mv ${DIR_TMP}/xray ${DIR_TMP}/Apppp


# Install V2Ray
install -m 755 ${DIR_TMP}/Apppp ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run V2Ray
${DIR_RUNTIME}/Apppp -config=${DIR_CONFIG}/c0nfig.json
