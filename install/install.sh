#/bin/env bash

# Script que instala umbrosio en el sistema

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INSTALL_PATH=/usr/local/bin

cp "${SCRIPT_DIR}/../src/umbrosio" "${INSTALL_PATH}/umbrosio"
chmod +x "${INSTALL_PATH}/umbrosio"
