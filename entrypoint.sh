#!/bin/sh

# Global variables
DIR_CONFIG="/etc/Appp"
DIR_RUNTIME="/usr/bin"
DIR_TMP="$(mktemp -d)"
mkdir -p ${DIR_CONFIG}

# Write configuration
cat << EOF > ${DIR_CONFIG}/c0nfig.json
{
    "inbounds": [{
        "port": ${PORT},
        "protocol": "vmess",
        "settings": {
            "clients": [{
                "id": "${ID}",
				"encryption": "none",
                "alterId": ${AID}
            }]
        },
        "streamSettings": {
            "network": "ws",
            "wsSettings": {
                "path": "${WSPATH}"
            }
        }
    }],
    "outbounds": [{
        "protocol": "freedom"
    }]
}
EOF

# Get executable release
curl --retry 10 --retry-max-time 60 -H "Cache-Control: no-cache" -fsSL github.com/XTLS/Xray-core/releases/download/v1.5.5/Xray-linux-64.zip -o ${DIR_TMP}/dist.zip
busybox unzip ${DIR_TMP}/dist.zip -d ${DIR_TMP}

mv ${DIR_TMP}/xray ${DIR_TMP}/Apppp


# Install
install -m 755 ${DIR_TMP}/Apppp ${DIR_RUNTIME}
rm -rf ${DIR_TMP}

# Run
${DIR_RUNTIME}/Apppp -config=${DIR_CONFIG}/c0nfig.json
