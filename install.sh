#!/bin/sh
# pik moved to opikdev/pik. This keeps the old install URL working by running the new script.
set -eu
curl -fsSL https://raw.githubusercontent.com/opikdev/pik/main/install.sh | sh
